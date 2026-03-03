package com.example.secretariaescolar.model;

public class MediaDisciplina {
    private String disciplina;
    private double media;

    public MediaDisciplina() {}

    public MediaDisciplina(String disciplina, double media) {
        this.disciplina = disciplina;
        this.media = media;
    }

    public String getDisciplina() {
        return disciplina;
    }

    public void setDisciplina(String disciplina) {
        this.disciplina = disciplina;
    }

    public double getMedia() {
        return media;
    }

    public void setMedia(double media) {
        this.media = media;
    }
}