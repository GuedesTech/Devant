package com.example.secretariaescolar.dto;

import com.example.secretariaescolar.model.Observacao;
import java.util.ArrayList;
import java.util.List;

public class AnaliseDisciplinaDTO {
    private int idDisciplina;
    private String nomeDisciplina;

    private double n1;
    private double n2;
    private double media;

    private int totalObs;
    private int totalElogios;
    private int totalPdm;

    private List<Observacao> observacoes = new ArrayList<>();

    public int getIdDisciplina() {
        return idDisciplina;
    }

    public void setIdDisciplina(int idDisciplina) {
        this.idDisciplina = idDisciplina;
    }

    public String getNomeDisciplina() {
        return nomeDisciplina;
    }

    public void setNomeDisciplina(String nomeDisciplina) {
        this.nomeDisciplina = nomeDisciplina;
    }

    public double getN1() {
        return n1;
    }

    public void setN1(double n1) {
        this.n1 = n1;
    }

    public double getN2() {
        return n2;
    }

    public void setN2(double n2) {
        this.n2 = n2;
    }

    public double getMedia() {
        return media;
    }

    public void setMedia(double media) {
        this.media = media;
    }

    public int getTotalObs() {
        return totalObs;
    }

    public void setTotalObs(int totalObs) {
        this.totalObs = totalObs;
    }

    public int getTotalElogios() {
        return totalElogios;
    }

    public void setTotalElogios(int totalElogios) {
        this.totalElogios = totalElogios;
    }

    public int getTotalPdm() {
        return totalPdm;
    }

    public void setTotalPdm(int totalPdm) {
        this.totalPdm = totalPdm;
    }

    public List<Observacao> getObservacoes() {
        return observacoes;
    }

    public void setObservacoes(List<Observacao> observacoes) {
        this.observacoes = observacoes;
    }
}