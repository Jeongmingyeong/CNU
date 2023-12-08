package org.example;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class SumTest {

    private static Sum sum_;
    @BeforeAll
    public static void SumTest() {
        sum_ = new Sum();
    }

    @Test
    @DisplayName("Positive Sum Test1")
    void postestSum1() {
        assertEquals(6, sum_.sum(3));
    }

    @Test
    @DisplayName("Positive Sum Test2")
    void postestSum2() {
        assertEquals(15, sum_.sum(5));
    }

    @Test
    @DisplayName("Negative Sum Test1")
    void negtestSum1() {
        assertEquals(-6, sum_.sum(-3));
    }
    @Test
    @DisplayName("Negative Sum Test2")
    void negtestSum2() {
        assertEquals(-15, sum_.sum(-5));
    }

    @Test
    @DisplayName("Zero Test")
    void zerotestSum() {
        assertEquals(0, sum_.sum(0));
    }
}