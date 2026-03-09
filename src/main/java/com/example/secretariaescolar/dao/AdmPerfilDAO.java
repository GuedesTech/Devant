package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.AdmPerfilView;
import com.example.secretariaescolar.util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AdmPerfilDAO {

    public AdmPerfilView buscarPorIdUser(int idUser) {
        String sql = """
            SELECT id_user, nome, login, senha, foto
            FROM usuario
            WHERE id_user = ? AND id_tipo_user = 3
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUser);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    AdmPerfilView adm = new AdmPerfilView();
                    adm.setIdUser(rs.getInt("id_user"));
                    adm.setNome(rs.getString("nome"));
                    adm.setLogin(rs.getString("login"));
                    adm.setSenha(rs.getString("senha"));
                    adm.setFoto(rs.getString("foto"));
                    return adm;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<AdmPerfilView> listarOutrosAdms(int idUserLogado) {
        List<AdmPerfilView> lista = new ArrayList<>();

        String sql = """
            SELECT id_user, nome, login, senha, foto
            FROM usuario
            WHERE id_tipo_user = 3
              AND id_user <> ?
            ORDER BY nome ASC
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUserLogado);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AdmPerfilView adm = new AdmPerfilView();
                    adm.setIdUser(rs.getInt("id_user"));
                    adm.setNome(rs.getString("nome"));
                    adm.setLogin(rs.getString("login"));
                    adm.setSenha(rs.getString("senha"));
                    adm.setFoto(rs.getString("foto"));
                    lista.add(adm);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public boolean inserir(String nome, String login, String senha, String fotoArquivo) {
        String sql = """
        INSERT INTO usuario (nome, login, senha, id_tipo_user, foto)
        VALUES (?, ?, ?, 3, ?)
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);
            stmt.setString(2, login);
            stmt.setString(3, senha);
            stmt.setString(4, fotoArquivo);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizar(int idUser, String nome, String login, String senha, String fotoArquivoNullable) {
        String sqlSemFoto = """
        UPDATE usuario
        SET nome = ?, login = ?, senha = ?
        WHERE id_user = ? AND id_tipo_user = 3
    """;

        String sqlComFoto = """
        UPDATE usuario
        SET nome = ?, login = ?, senha = ?, foto = ?
        WHERE id_user = ? AND id_tipo_user = 3
    """;

        try (Connection conn = Conexao.conectar()) {

            if (fotoArquivoNullable == null) {
                try (PreparedStatement stmt = conn.prepareStatement(sqlSemFoto)) {
                    stmt.setString(1, nome);
                    stmt.setString(2, login);
                    stmt.setString(3, senha);
                    stmt.setInt(4, idUser);
                    return stmt.executeUpdate() > 0;
                }
            } else {
                try (PreparedStatement stmt = conn.prepareStatement(sqlComFoto)) {
                    stmt.setString(1, nome);
                    stmt.setString(2, login);
                    stmt.setString(3, senha);
                    stmt.setString(4, fotoArquivoNullable);
                    stmt.setInt(5, idUser);
                    return stmt.executeUpdate() > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean excluir(int idUser) {
        String sql = "DELETE FROM usuario WHERE id_user = ? AND id_tipo_user = 3";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUser);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}