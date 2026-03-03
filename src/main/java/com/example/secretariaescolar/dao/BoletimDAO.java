package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Observacao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BoletimDAO {
    private final Connection conn;

    public BoletimDAO(Connection conn) {
        this.conn = conn;
    }

    public String buscarNomeDisciplina(int idDisciplina) throws SQLException {
        String sql = "SELECT nome FROM disciplina WHERE id_disciplina = ?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, idDisciplina);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getString("nome");
                return null;
            }
        }
    }

    // Pega uma nota do semestre (se existir). Se tiver mais de uma por semestre, pega a maior.
    public Double buscarNotaSemestre(int idAluno, int idDisciplina, String semestre) throws SQLException {
        String sql = """
            SELECT MAX(valor) AS nota
            FROM nota
            WHERE id_aluno = ?
              AND id_disciplina = ?
              AND semestre = ?
        """;
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, idAluno);
            st.setInt(2, idDisciplina);
            st.setString(3, semestre);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    double v = rs.getDouble("nota");
                    return rs.wasNull() ? null : v;
                }
                return null;
            }
        }
    }

    // Média da disciplina (média de todas as notas daquela disciplina)
    public Double buscarMediaDisciplina(int idAluno, int idDisciplina) throws SQLException {
        String sql = """
            SELECT ROUND(AVG(valor), 2) AS media
            FROM nota
            WHERE id_aluno = ?
              AND id_disciplina = ?
        """;
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, idAluno);
            st.setInt(2, idDisciplina);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    double v = rs.getDouble("media");
                    return rs.wasNull() ? null : v;
                }
                return null;
            }
        }
    }

    public int contarObservacoes(int idAluno, int idDisciplina) throws SQLException {
        String sql = """
            SELECT COUNT(*) AS total
            FROM observacao
            WHERE id_aluno = ?
              AND id_disciplina = ?
        """;
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, idAluno);
            st.setInt(2, idDisciplina);
            try (ResultSet rs = st.executeQuery()) {
                rs.next();
                return rs.getInt("total");
            }
        }
    }

    public int contarObservacoesPorTipo(int idAluno, int idDisciplina, int tipo) throws SQLException {
        String sql = """
            SELECT COUNT(*) AS total
            FROM observacao
            WHERE id_aluno = ?
              AND id_disciplina = ?
              AND tipo = ?
        """;
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, idAluno);
            st.setInt(2, idDisciplina);
            st.setInt(3, tipo);
            try (ResultSet rs = st.executeQuery()) {
                rs.next();
                return rs.getInt("total");
            }
        }
    }

    // ✅ Observações da disciplina + nome do professor (via professor -> usuario)
    public List<Observacao> listarObservacoesDaDisciplina(int idAluno, int idDisciplina) throws SQLException {
        List<Observacao> list = new ArrayList<>();

        String sql = """
            SELECT o.id_observacao, o.mensagem, o.data, o.id_aluno, o.id_professor, o.id_disciplina, o.tipo,
                   u.nome AS nome_professor
            FROM observacao o
            JOIN professor p ON p.id_professor = o.id_professor
            JOIN usuario u   ON u.id_user = p.id_user
            WHERE o.id_aluno = ?
              AND o.id_disciplina = ?
            ORDER BY o.data DESC, o.id_observacao DESC
        """;

        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, idAluno);
            st.setInt(2, idDisciplina);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Observacao obs = new Observacao(
                            rs.getInt("id_observacao"),
                            rs.getString("mensagem"),
                            rs.getDate("data").toLocalDate(),
                            rs.getInt("id_aluno"),
                            rs.getInt("id_professor"),
                            rs.getInt("id_disciplina"),
                            rs.getInt("tipo")
                    );

                    obs.setNomeProfessor(rs.getString("nome_professor")); // ✅ aqui

                    list.add(obs);
                }
            }
        }

        return list;
    }
}