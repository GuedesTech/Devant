package com.example.secretariaescolar.model;

public class Professor extends Usuario {

    private int id_professor;
    private int id_user;
    private int id_disciplina;

    public Professor() {
        super();
    }

    public Professor(int id_professor) {
        this.id_professor = id_professor;
    }

    public int getId_professor() {
        return id_professor;
    }

    public void setId_professor(int id_professor) {
        this.id_professor = id_professor;
    }

    public int getId_user() {
        return id_user;
    }

    public void setId_user(int id_user) {
        this.id_user = id_user;
    }

    public int getId_disciplina() {
        return id_disciplina;
    }

    public void setId_disciplina(int id_disciplina) {
        this.id_disciplina = id_disciplina;
    }
}