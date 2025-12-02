package org.example;

public class Sum {
    public int sum(int n) {
        int total = 0;
        int last = n;

        if(n < 0) {
            last = -n;
        }

        for(int i = 1; i <= last; i++) {
            total = total + i;
        }

        if(n < 0) {
            total = -total;
        }

        return total;
    }
}
