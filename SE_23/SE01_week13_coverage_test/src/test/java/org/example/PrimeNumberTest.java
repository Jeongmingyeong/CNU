package org.example;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PrimeNumberTest {

    private static PrimeNumber pn;

    @BeforeAll
    public static void PrimeNumberTest() {
        pn = new PrimeNumber();
    }

    @Test
    @DisplayName("Primenumber Test1")
    void isPrimeNumberTest1() {
        assertFalse(pn.isPrimeNumber(0));
    }

    @Test
    @DisplayName("Primenumber Test2")
    void isPrimeNumberTest2() {
        assertFalse(pn.isPrimeNumber(1));
    }

    @Test
    @DisplayName("Primenumber Test3")
    void isPrimeNumberTest3() {
        assertTrue(pn.isPrimeNumber(2));
    }

    @Test
    @DisplayName("Primenumber Test4")
    void isPrimeNumberTest4() {
        assertTrue(pn.isPrimeNumber(3));
    }

    @Test
    @DisplayName("Primenumber Test5")
    void isPrimeNumberTest5() {
        assertFalse(pn.isPrimeNumber(27));
    }

    @Test
    @DisplayName("Primenumber Test6")
    void isPrimeNumberTest6() {
        assertTrue(pn.isPrimeNumber(59));
    }
}