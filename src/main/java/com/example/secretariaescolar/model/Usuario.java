package com.example.secretariaescolar.model;

public class Usuario {

    private int id_user;
    private String nome;
    private String login;
    private String senha;
    private int id_tipo_user;
    private String foto;

    public Usuario(String nome, String login, String senha, int id_tipo_user) {
        this.nome = nome;
        this.login = login;
        this.senha = senha;
        this.id_tipo_user = id_tipo_user;
    }

    public Usuario() {}

    public int getId_user() {
        return id_user;
    }

    public void setId_user(int id_user) {
        this.id_user = id_user;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public int getId_tipo_user() {
        return id_tipo_user;
    }

    public void setId_tipo_user(int id_tipo_user) {
        this.id_tipo_user = id_tipo_user;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }
}