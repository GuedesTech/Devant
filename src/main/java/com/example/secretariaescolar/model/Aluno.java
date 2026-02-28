package com.example.secretariaescolar.model;

public class Aluno extends Usuario {

    private int id_aluno;
    private String matricula;
    private int id_turma;
    private String nomeTurma;

    public Aluno(int id_aluno, String matricula, int id_turma,
                 String nome, String login, String senha, int id_tipo_user) {

        super(nome, login, senha, id_tipo_user);
        this.id_aluno = id_aluno;
        this.matricula = matricula;
        this.id_turma = id_turma;
    }

    public Aluno(String matricula, int id_turma,
                 String nome, String login, String senha, int id_tipo_user) {

        super(nome, login, senha, id_tipo_user);
        this.matricula = matricula;
        this.id_turma = id_turma;
    }

    public Aluno() {}

    public int getId_aluno() {
        return id_aluno;
    }

    public void setId_aluno(int id_aluno) {
        this.id_aluno = id_aluno;
    }

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    public int getId_turma() {
        return id_turma;
    }

    public void setId_turma(int id_turma) {
        this.id_turma = id_turma;
    }

    public String getNomeTurma() { return nomeTurma; }
    public void setNomeTurma(String nomeTurma) { this.nomeTurma = nomeTurma; }
}