package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.ObservacaoAdmView;
import com.example.secretariaescolar.util.Conexao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ObservacaoAdmDAO {

    public List<ObservacaoAdmView> listar(String q) {
        List<ObservacaoAdmView> lista = new ArrayList<>();

        String sql = """
            SELECT
                o.id_observacao,
                o.id_aluno,
                o.id_professor,
                o.id_disciplina,
                o.mensagem,
                o.data,
                o.tipo,
                u_aluno.nome AS nome_aluno,
                d.nome AS nome_disciplina,
                CASE
                    WHEN o.id_professor IS NULL THEN 'Secretaria'
                    ELSE u_prof.nome
                END AS autor
            FROM observacao o
            JOIN aluno a ON a.id_aluno = o.id_aluno
            JOIN usuario u_aluno ON u_aluno.id_user = a.id_user
            LEFT JOIN professor p ON p.id_professor = o.id_professor
            LEFT JOIN usuario u_prof ON u_prof.id_user = p.id_user
            LEFT JOIN disciplina d ON d.id_disciplina = o.id_disciplina
            WHERE (
                ? IS NULL
                OR LOWER(u_aluno.nome) LIKE ?
                OR LOWER(COALESCE(u_prof.nome, 'Secretaria')) LIKE ?
                OR LOWER(COALESCE(d.nome, '')) LIKE ?
                OR LOWER(o.mensagem) LIKE ?
            )
            ORDER BY o.data DESC, o.id_observacao DESC
        """;

        String like = (q == null || q.isBlank()) ? null : "%" + q.toLowerCase() + "%";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, like);
            stmt.setString(2, like);
            stmt.setString(3, like);
            stmt.setString(4, like);
            stmt.setString(5, like);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ObservacaoAdmView o = new ObservacaoAdmView();

                    o.setIdObservacao(rs.getInt("id_observacao"));

                    Object idAluno = rs.getObject("id_aluno");
                    if (idAluno != null) o.setIdAluno(((Number) idAluno).intValue());

                    Object idProfessor = rs.getObject("id_professor");
                    if (idProfessor != null) o.setIdProfessor(((Number) idProfessor).intValue());

                    Object idDisciplina = rs.getObject("id_disciplina");
                    if (idDisciplina != null) o.setIdDisciplina(((Number) idDisciplina).intValue());

                    o.setMensagem(rs.getString("mensagem"));
                    Date data = rs.getDate("data");
                    if (data != null) o.setData(data.toLocalDate());

                    o.setTipo(rs.getInt("tipo"));
                    o.setNomeAluno(rs.getString("nome_aluno"));
                    o.setNomeDisciplina(rs.getString("nome_disciplina"));
                    o.setAutor(rs.getString("autor"));

                    lista.add(o);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public boolean inserir(Integer idAluno, Integer idDisciplina, String mensagem, int tipo, Date data) {
        String sql = """
            INSERT INTO observacao (mensagem, data, id_aluno, id_professor, id_disciplina, tipo)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, mensagem);
            stmt.setDate(2, data);
            stmt.setInt(3, idAluno);

            stmt.setNull(4, java.sql.Types.INTEGER);

            if (idDisciplina == null) stmt.setNull(5, java.sql.Types.INTEGER);
            else stmt.setInt(5, idDisciplina);

            stmt.setInt(6, tipo);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizar(int idObservacao, Integer idAluno, Integer idDisciplina, String mensagem, int tipo, Date data) {
        String sql = """
            UPDATE observacao
            SET mensagem = ?, data = ?, id_aluno = ?, id_disciplina = ?, tipo = ?
            WHERE id_observacao = ?
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, mensagem);
            stmt.setDate(2, data);
            stmt.setInt(3, idAluno);

            if (idDisciplina == null) stmt.setNull(4, java.sql.Types.INTEGER);
            else stmt.setInt(4, idDisciplina);

            stmt.setInt(5, tipo);
            stmt.setInt(6, idObservacao);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean excluir(int idObservacao) {
        String sql = "DELETE FROM observacao WHERE id_observacao = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idObservacao);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}