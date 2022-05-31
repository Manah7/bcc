void demo() {
    int a = 1;
    int b = 2 + a;
    print(a);
    print(b);
    return;
}

void foo() {
    int lambda = 1;
    return;
}

int main(){
    int b = 8;
    while (b > 0) {
        b = b - 1;
        foo();
    }

    int a = b << 2;

    demo();
}