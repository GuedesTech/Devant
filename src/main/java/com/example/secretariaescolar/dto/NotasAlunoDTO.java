package com.example.secretariaescolar.dto;

public class NotasAlunoDTO {
    private double n1;
    private double n2;

    public double getN1() { return n1; }
    public void setN1(double n1) { this.n1 = n1; }

    public double getN2() { return n2; }
    public void setN2(double n2) { this.n2 = n2; }

    public double getMedia() {
        return Math.round(((n1 + n2) / 2.0) * 10.0) / 10.0;
    }
}