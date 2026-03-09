package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.dto.NotasAlunoDTO;
import com.example.secretariaescolar.model.AlunoAdmView;
import com.example.secretariaescolar.util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AlunoAdmDAO {

    public List<AlunoAdmView> listar(String q) {
        List<AlunoAdmView> list = new ArrayList<>();

        String sql = """
            SELECT 
              a.id_aluno,
              a.matricula,
              a.id_turma,
              t.nome AS nome_turma,
              u.id_user,
              u.nome,
              u.login,
              u.senha,
              u.foto
            FROM aluno a
            JOIN usuario u ON u.id_user = a.id_user
            JOIN turma t ON t.id_turma = a.id_turma
            WHERE (? IS NULL OR LOWER(u.nome) LIKE ? OR LOWER(a.matricula) LIKE ? OR LOWER(t.nome) LIKE ?)
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
                    AlunoAdmView a = new AlunoAdmView();
                    a.setIdAluno(rs.getInt("id_aluno"));
                    a.setMatricula(rs.getString("matricula"));
                    a.setIdTurma(rs.getInt("id_turma"));
                    a.setNomeTurma(rs.getString("nome_turma"));

                    a.setIdUser(rs.getInt("id_user"));
                    a.setNome(rs.getString("nome"));
                    a.setLogin(rs.getString("login"));
                    a.setSenha(rs.getString("senha"));
                    a.setFoto(rs.getString("foto"));

                    list.add(a);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public AlunoAdmView buscarPorIdAluno(int idAluno) {
        String sql = """
            SELECT 
              a.id_aluno, a.matricula, a.id_turma, t.nome AS nome_turma,
              u.id_user, u.nome, u.login, u.senha, u.foto
            FROM aluno a
            JOIN usuario u ON u.id_user = a.id_user
            JOIN turma t ON t.id_turma = a.id_turma
            WHERE a.id_aluno = ?
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    AlunoAdmView a = new AlunoAdmView();
                    a.setIdAluno(rs.getInt("id_aluno"));
                    a.setMatricula(rs.getString("matricula"));
                    a.setIdTurma(rs.getInt("id_turma"));
                    a.setNomeTurma(rs.getString("nome_turma"));

                    a.setIdUser(rs.getInt("id_user"));
                    a.setNome(rs.getString("nome"));
                    a.setLogin(rs.getString("login"));
                    a.setSenha(rs.getString("senha"));
                    a.setFoto(rs.getString("foto"));
                    return a;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean inserir(String nome, String matricula, int idTurma, String fotoArquivo) {
        String sqlUser = "INSERT INTO usuario (nome, login, senha, id_tipo_user, foto) VALUES (?, NULL, NULL, 1, ?) RETURNING id_user";
        String sqlAluno = "INSERT INTO aluno (id_user, matricula, id_turma) VALUES (?, ?, ?)";

        try (Connection conn = Conexao.conectar()) {
            conn.setAutoCommit(false);

            int idUser;

            try (PreparedStatement s1 = conn.prepareStatement(sqlUser)) {
                s1.setString(1, nome);
                s1.setString(2, fotoArquivo);
                try (ResultSet rs = s1.executeQuery()) {
                    if (!rs.next()) { conn.rollback(); return false; }
                    idUser = rs.getInt("id_user");
                }
            }

            try (PreparedStatement s2 = conn.prepareStatement(sqlAluno)) {
                s2.setInt(1, idUser);
                s2.setString(2, matricula);
                s2.setInt(3, idTurma);
                s2.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizar(int idAluno, String nome, String matricula, int idTurma,
                             String login, String senha, String fotoArquivoNullable) {

        String sqlGet = "SELECT id_user FROM aluno WHERE id_aluno = ?";
        String sqlUserNoFoto = "UPDATE usuario SET nome=?, login=?, senha=? WHERE id_user=?";
        String sqlUserComFoto = "UPDATE usuario SET nome=?, login=?, senha=?, foto=? WHERE id_user=?";
        String sqlAluno = "UPDATE aluno SET matricula=?, id_turma=? WHERE id_aluno=?";

        try (Connection conn = Conexao.conectar()) {
            conn.setAutoCommit(false);

            int idUser;
            try (PreparedStatement g = conn.prepareStatement(sqlGet)) {
                g.setInt(1, idAluno);
                try (ResultSet rs = g.executeQuery()) {
                    if (!rs.next()) { conn.rollback(); return false; }
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

            try (PreparedStatement a = conn.prepareStatement(sqlAluno)) {
                a.setString(1, matricula);
                a.setInt(2, idTurma);
                a.setInt(3, idAluno);
                a.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean excluir(int idAluno) {
        String sqlGet = "SELECT id_user FROM aluno WHERE id_aluno = ?";
        String sqlDel = "DELETE FROM usuario WHERE id_user = ?";

        try (Connection conn = Conexao.conectar()) {
            int idUser;

            try (PreparedStatement g = conn.prepareStatement(sqlGet)) {
                g.setInt(1, idAluno);
                try (ResultSet rs = g.executeQuery()) {
                    if (!rs.next()) return false;
                    idUser = rs.getInt("id_user");
                }
            }

            try (PreparedStatement d = conn.prepareStatement(sqlDel)) {
                d.setInt(1, idUser);
                return d.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, NotasAlunoDTO> buscarNotasMap() {
        Map<String, NotasAlunoDTO> mapa = new HashMap<>();

        String sql = """
        SELECT
            id_aluno,
            id_disciplina,
            MAX(CASE WHEN semestre = '1' THEN valor END) AS n1,
            MAX(CASE WHEN semestre = '2' THEN valor END) AS n2
        FROM nota
        GROUP BY id_aluno, id_disciplina
    """;

        try (Connection con = Conexao.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int idAluno = rs.getInt("id_aluno");
                int idDisciplina = rs.getInt("id_disciplina");

                double n1 = rs.getDouble("n1");
                if (rs.wasNull()) n1 = 0.0;

                double n2 = rs.getDouble("n2");
                if (rs.wasNull()) n2 = 0.0;

                NotasAlunoDTO dto = new NotasAlunoDTO();
                dto.setN1(n1);
                dto.setN2(n2);

                mapa.put(idAluno + "_" + idDisciplina, dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return mapa;
    }
}