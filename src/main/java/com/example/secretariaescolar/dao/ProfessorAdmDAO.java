package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.ProfessorAdmView;
import com.example.secretariaescolar.util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProfessorAdmDAO {

    public List<ProfessorAdmView> listar(String q) {
        List<ProfessorAdmView> list = new ArrayList<>();

        String sql = """
            SELECT
                p.id_professor,
                p.id_disciplina,
                d.nome AS nome_disciplina,
                u.id_user,
                u.nome,
                u.login,
                u.senha,
                u.foto
            FROM professor p
            JOIN usuario u ON u.id_user = p.id_user
            JOIN disciplina d ON d.id_disciplina = p.id_disciplina
            WHERE u.id_tipo_user = 2
              AND (? IS NULL OR LOWER(u.nome) LIKE ? OR LOWER(u.login) LIKE ? OR LOWER(d.nome) LIKE ?)
            ORDER BY u.nome ASC
        """;

        String like = (q == null || q.isBlank()) ? null : "%" + q.toLowerCase() + "%";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, like);
            stmt.setString(2, like);
            stmt.setString(3, like);
            stmt.setString(4, like);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProfessorAdmView p = new ProfessorAdmView();
                    p.setIdProfessor(rs.getInt("id_professor"));
                    p.setIdDisciplina(rs.getInt("id_disciplina"));
                    p.setNomeDisciplina(rs.getString("nome_disciplina"));
                    p.setIdUser(rs.getInt("id_user"));
                    p.setNome(rs.getString("nome"));
                    p.setLogin(rs.getString("login"));
                    p.setSenha(rs.getString("senha"));
                    p.setFoto(rs.getString("foto"));
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public ProfessorAdmView buscarPorIdProfessor(int idProfessor) {
        String sql = """
            SELECT
                p.id_professor,
                p.id_disciplina,
                d.nome AS nome_disciplina,
                u.id_user,
                u.nome,
                u.login,
                u.senha,
                u.foto
            FROM professor p
            JOIN usuario u ON u.id_user = p.id_user
            JOIN disciplina d ON d.id_disciplina = p.id_disciplina
            WHERE p.id_professor = ?
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProfessor);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ProfessorAdmView p = new ProfessorAdmView();
                    p.setIdProfessor(rs.getInt("id_professor"));
                    p.setIdDisciplina(rs.getInt("id_disciplina"));
                    p.setNomeDisciplina(rs.getString("nome_disciplina"));
                    p.setIdUser(rs.getInt("id_user"));
                    p.setNome(rs.getString("nome"));
                    p.setLogin(rs.getString("login"));
                    p.setSenha(rs.getString("senha"));
                    p.setFoto(rs.getString("foto"));
                    return p;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean inserir(String nome, String login, String senha, int idDisciplina, String fotoArquivo) {
        String sqlUser = """
            INSERT INTO usuario (nome, login, senha, id_tipo_user, foto)
            VALUES (?, ?, ?, 2, ?)
            RETURNING id_user
        """;

        String sqlProfessor = """
            INSERT INTO professor (id_user, id_disciplina)
            VALUES (?, ?)
        """;

        try (Connection conn = Conexao.conectar()) {
            conn.setAutoCommit(false);

            int idUser;

            try (PreparedStatement s1 = conn.prepareStatement(sqlUser)) {
                s1.setString(1, nome);
                s1.setString(2, login);
                s1.setString(3, senha);
                s1.setString(4, fotoArquivo);

                try (ResultSet rs = s1.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    idUser = rs.getInt("id_user");
                }
            }

            try (PreparedStatement s2 = conn.prepareStatement(sqlProfessor)) {
                s2.setInt(1, idUser);
                s2.setInt(2, idDisciplina);
                s2.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizar(int idProfessor, String nome, String login, String senha,
                             int idDisciplina, String fotoArquivoNullable) {

        String sqlGet = "SELECT id_user FROM professor WHERE id_professor = ?";
        String sqlUserNoFoto = "UPDATE usuario SET nome=?, login=?, senha=? WHERE id_user=?";
        String sqlUserComFoto = "UPDATE usuario SET nome=?, login=?, senha=?, foto=? WHERE id_user=?";
        String sqlProfessor = "UPDATE professor SET id_disciplina=? WHERE id_professor=?";

        try (Connection conn = Conexao.conectar()) {
            conn.setAutoCommit(false);

            int idUser;

            try (PreparedStatement g = conn.prepareStatement(sqlGet)) {
                g.setInt(1, idProfessor);

                try (ResultSet rs = g.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                    idUser = rs.getInt("id_user");
                }
            }

            if (fotoArquivoNullable == null) {
                try (PreparedStatement u = conn.prepareStatement(sqlUserNoFoto)) {
                    u.setString(1, nome);
                    u.setString(2, login);
                    u.setString(3, senha);
                    u.setInt(4, idUser);
                    u.executeUpdate();
                }
            } else {
                try (PreparedStatement u = conn.prepareStatement(sqlUserComFoto)) {
                    u.setString(1, nome);
                    u.setString(2, login);
                    u.setString(3, senha);
                    u.setString(4, fotoArquivoNullable);
                    u.setInt(5, idUser);
                    u.executeUpdate();
                }
            }

            try (PreparedStatement p = conn.prepareStatement(sqlProfessor)) {
                p.setInt(1, idDisciplina);
                p.setInt(2, idProfessor);
                p.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean excluir(int idProfessor) {
        String sqlGet = "SELECT id_user FROM professor WHERE id_professor = ?";
        String sqlDelete = "DELETE FROM usuario WHERE id_user = ?";

        try (Connection conn = Conexao.conectar()) {
            int idUser;

            try (PreparedStatement g = conn.prepareStatement(sqlGet)) {
                g.setInt(1, idProfessor);

                try (ResultSet rs = g.executeQuery()) {
                    if (!rs.next()) return false;
                    idUser = rs.getInt("id_user");
                }
            }

            try (PreparedStatement d = conn.prepareStatement(sqlDelete)) {
                d.setInt(1, idUser);
                return d.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}