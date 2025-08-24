import std.array : replicate;
import std.stdio;
import std.algorithm;
import std.random;
import std.datetime;
import core.thread;
import core.stdc.stdlib;
import core.sys.posix.termios;
import core.sys.posix.unistd;
import core.sys.posix.sys.select;

struct Point {
    int x, y;
    Point opBinary(string op)(Point other) if (op == "+") {
        return Point(x + other.x, y + other.y);
    }
}

enum Direction { UP, DOWN, LEFT, RIGHT }

class Snake {
    private Point[] body;
    private Direction currentDirection;
    private const int boardWidth, boardHeight;

    this(int width, int height) {
        boardWidth = width;
        boardHeight = height;
        auto startX = width / 2;
        auto startY = height / 2;
        currentDirection = Direction.RIGHT;

        body = [
            Point(startX,     startY),
            Point(startX - 1, startY),
            Point(startX - 2, startY)
        ];
    }

    Point getDirectionVector(Direction dir) {
        final switch (dir) {
            case Direction.UP:    return Point(0, -1);
            case Direction.DOWN:  return Point(0, 1);
            case Direction.LEFT:  return Point(-1, 0);
            case Direction.RIGHT: return Point(1, 0);
        }
    }

    void changeDirection(Direction newDir) {
        if (body.length > 1) {
            Direction opposite;
            final switch (newDir) {
                case Direction.UP:    opposite = Direction.DOWN; break;
                case Direction.DOWN:  opposite = Direction.UP; break;
                case Direction.LEFT:  opposite = Direction.RIGHT; break;
                case Direction.RIGHT: opposite = Direction.LEFT; break;
            }
            if (opposite == currentDirection) return;
        }
        currentDirection = newDir;
    }

    private Point wrap(Point p) {
        if (p.x < 0) p.x = boardWidth - 1;
        else if (p.x >= boardWidth) p.x = 0;
        if (p.y < 0) p.y = boardHeight - 1;
        else if (p.y >= boardHeight) p.y = 0;
        return p;
    }

    void move() {
        body = wrap(body[0] + getDirectionVector(currentDirection)) ~ body[0 .. $-1];
    }

    void grow() {
        body = wrap(body[0] + getDirectionVector(currentDirection)) ~ body;
    }

    Point[] getBody() const { return body.dup; }

    bool checkSelfCollision() const {
        return body.length > 1 && body[1..$].canFind(body[0]);
    }
}

class Game {
    private Snake snake;
    private const int width, height;
    private bool running = true;
    private Point food;
    private int score;
    private Random rng;
    private termios originalTermios;

    this(int w = 40, int h = 20) {
        width = w; height = h;
        snake = new Snake(width, height);
        rng = Random(cast(uint)Clock.currTime.toUnixTime());
        generateFood();
    }

    Point[] getFoodPositions() {
        Point[] pos;
        foreach (i; 0 .. 6)
            if (food.x + i < width) pos ~= Point(food.x + i, food.y);
        return pos;
    }

    void generateFood() {
        bool valid;
        do {
            food = Point(uniform(0, width - 5, rng), uniform(0, height, rng));
            valid = getFoodPositions().all!(p => !snake.getBody().canFind(p));
        } while (!valid);
    }

    void processInput() {
        fd_set readfds; FD_ZERO(&readfds); FD_SET(STDIN_FILENO, &readfds);
        timeval timeout = timeval(0, 0);
        if (select(STDIN_FILENO + 1, &readfds, null, null, &timeout) > 0) {
            char ch; if (read(STDIN_FILENO, &ch, 1) > 0) {
                final switch (ch) {
                    case 'w','W': snake.changeDirection(Direction.UP); break;
                    case 's','S': snake.changeDirection(Direction.DOWN); break;
                    case 'a','A': snake.changeDirection(Direction.LEFT); break;
                    case 'd','D': snake.changeDirection(Direction.RIGHT); break;
                    case 'q','Q': running = false; break;
                }
            }
        }
    }

    void update() {
        snake.move();
        auto head = snake.getBody()[0];
        if (getFoodPositions().canFind(head)) {
            score++;
            snake.grow();
            generateFood();
        }
        if (snake.checkSelfCollision()) running = false;
    }

    // Helpers for rendering
    int normDelta(int d, int size) {
        if (d > size / 2) return d - size;
        if (d < -size / 2) return d + size;
        return d;
    }
    Direction dirBetween(Point from, Point to) {
        int dx = normDelta(to.x - from.x, width);
        int dy = normDelta(to.y - from.y, height);
        if (dx ==  1) return Direction.RIGHT;
        if (dx == -1) return Direction.LEFT;
        if (dy ==  1) return Direction.DOWN;
        if (dy == -1) return Direction.UP;
        return Direction.RIGHT;
    }
    wchar endChar(Direction dir, bool head) {
        final switch (dir) {
            case Direction.RIGHT: return head ? 'D' : '8';
            case Direction.LEFT:  return head ? 'ᗡ' : '8';
            case Direction.UP:    return head ? '⋂' : '∞';
            case Direction.DOWN:  return head ? '⋃' : '∞';
        }
    }
    wchar cornerChar(Direction a, Direction b) {
        if ((a == Direction.RIGHT && b == Direction.DOWN) ||
            (b == Direction.RIGHT && a == Direction.DOWN)) return '╔';
        if ((a == Direction.LEFT && b == Direction.DOWN) ||
            (b == Direction.LEFT && a == Direction.DOWN)) return '╗';
        if ((a == Direction.LEFT && b == Direction.UP)   ||
            (b == Direction.LEFT && a == Direction.UP))   return '╝';
        if ((a == Direction.RIGHT && b == Direction.UP)  ||
            (b == Direction.RIGHT && a == Direction.UP))  return '╚';
        return '+';
    }

    void render() {
        system("clear");
        auto snakeBody = snake.getBody();
        wchar[][] board = new wchar[][](height, width);
        foreach (ref row; board) row[] = ' ';

        // Food pattern
        if (food.x + 5 < width) {
            board[food.y][food.x .. food.x+6] = ['(','*',')','(','*',')'];
        } else board[food.y][food.x] = '*';

        if (snakeBody.length == 1) {
            auto p = snakeBody[0];
            board[p.y][p.x] = endChar(Direction.RIGHT, true);
        } else {
            auto head = snakeBody[0], nxt = snakeBody[1];
            board[head.y][head.x] = endChar(dirBetween(nxt, head), true);
            auto tail = snakeBody[$-1], prev = snakeBody[$-2];
            board[tail.y][tail.x] = endChar(dirBetween(prev, tail), false);
            foreach (i; 1 .. snakeBody.length-1) {
                auto cur = snakeBody[i], prev2 = snakeBody[i-1], next = snakeBody[i+1];
                Direction d1 = dirBetween(cur, prev2), d2 = dirBetween(cur, next);
                if ((d1 == Direction.LEFT || d1 == Direction.RIGHT) && (d2 == Direction.LEFT || d2 == Direction.RIGHT)) board[cur.y][cur.x] = '=';
                else if ((d1 == Direction.UP || d1 == Direction.DOWN) && (d2 == Direction.UP || d2 == Direction.DOWN)) board[cur.y][cur.x] = '║';
                else board[cur.y][cur.x] = cornerChar(d1, d2);
            }
        }

        write("+", replicate("-", width), "+\n");
        foreach (y; 0 .. height) {
            write("|"); foreach (x; 0 .. width) write(board[y][x]); writeln("|");
        }
        write("+", replicate("-", width), "+\n");
        writeln("score: ", score, "   controls: wasd, q quit");
        stdout.flush();
    }

    void setupTerminal() {
        tcgetattr(STDIN_FILENO, &originalTermios);
        termios raw = originalTermios;
        raw.c_lflag &= ~(ICANON | ECHO);
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
    }
    void restoreTerminal() { tcsetattr(STDIN_FILENO, TCSAFLUSH, &originalTermios); }

    void run() {
        setupTerminal(); scope(exit) restoreTerminal();
        while (running) {
            processInput(); update(); render();
            Thread.sleep(dur!"msecs"(150));
        }
        writeln("\ngame over, final score: ", score);
    }
}

void main() {
    writeln("use wasd to move\neat (*)(*) to grow\nq to quit\npress enter to start...");
    readln();
    new Game().run();
}
