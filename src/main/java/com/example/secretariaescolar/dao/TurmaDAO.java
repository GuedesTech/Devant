package com.example.secretariaescolar.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.util.Conexao;

public class TurmaDAO {

    public int inserir(Turma turma) {

        String sql = "INSERT INTO Turma (nome) VALUES (?)";
        int idGerado = -1;

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, turma.getNome());

            int linhasAfetadas = stmt.executeUpdate();

            if (linhasAfetadas > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        idGerado = rs.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao inserir turma: " + e.getMessage());
        }

        return idGerado;
    }

    public List<Turma> listarTodas() {
        List<Turma> turmas = new ArrayList<>();

        String sql = "SELECT * FROM Turma";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Turma turma = new Turma();

                turma.setId_turma(rs.getInt("id_turma"));
                turma.setNome(rs.getString("nome"));

                turmas.add(turma);
            }

        } catch (SQLException e) {
            System.err.println("Erro ao listar todas as turmas: " + e.getMessage());
        }

        return turmas;
    }

    public Turma buscarPorId(int idTurma) {
        String sql = "SELECT * FROM Turma WHERE id_turma = ?";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Turma turma = new Turma();

                    turma.setId_turma(rs.getInt("id_turma"));
                    turma.setNome(rs.getString("nome"));

                    return turma;
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar turma por ID: " + e.getMessage());
        }

        return null;
    }

    public boolean atualizar(Turma turma) {
        String sql = "UPDATE Turma SET nome = ? WHERE id_turma = ?";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, turma.getNome());
            stmt.setInt(2, turma.getId_turma());

            int linhasAfetadas = stmt.executeUpdate();

            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao atualizar as turmas: " + e.getMessage());
            return false;
        }

    }

    public boolean deletar(int idTurma) {
        String sql = "DELETE FROM Turma WHERE id_turma = ?";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);

            int linhasAfetadas = stmt.executeUpdate();

            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao deletar turma: " + e.getMessage());
            return false;
        }
    }

    public int contarTotalAlunos() {
        String sql = "SELECT COUNT(*) AS total FROM aluno";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) return rs.getInt("total");

        } catch (SQLException e) {
            System.err.println("Erro ao contar alunos: " + e.getMessage());
        }

        return 0;
    }

    public java.util.Map<Integer, Double> buscarMediaPorTurma() {
        java.util.Map<Integer, Double> map = new java.util.HashMap<>();

        String sql = """
        SELECT a.id_turma, ROUND(AVG(n.valor), 1) AS media
        FROM aluno a
        JOIN nota n ON n.id_aluno = a.id_aluno
        GROUP BY a.id_turma
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int idTurma = rs.getInt("id_turma");
                double media = rs.getDouble("media");
                map.put(idTurma, media);
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar média por turma: " + e.getMessage());
        }

        return map;
    }

    // ===============================
// MÉTRICAS DA TURMA (TELA DETALHE)
// ===============================

    public int contarAlunosDaTurma(int idTurma) {
        String sql = "SELECT COUNT(*) AS total FROM aluno WHERE id_turma = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Erro ao contar alunos da turma: " + e.getMessage());
        }
        return 0;
    }

    public double buscarMediaTurma(int idTurma) {
        String sql = """
        SELECT ROUND(AVG(n.valor), 1) AS media
        FROM nota n
        JOIN aluno a ON a.id_aluno = n.id_aluno
        WHERE a.id_turma = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double v = rs.getDouble("media");
                    return rs.wasNull() ? 0.0 : v;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar média da turma: " + e.getMessage());
        }
        return 0.0;
    }

    /**
     * Conta alunos cuja MÉDIA do aluno (AVG das notas do aluno) é >= limite
     */
    public int contarAlunosComMediaAcimaDe(int idTurma, double limite) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT a.id_aluno, AVG(n.valor) AS media_aluno
            FROM aluno a
            LEFT JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE a.id_turma = ?
            GROUP BY a.id_aluno
        ) x
        WHERE COALESCE(x.media_aluno, 0) >= ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);
            stmt.setDouble(2, limite);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Erro ao contar alunos acima de: " + e.getMessage());
        }
        return 0;
    }

    public int contarAlunosComMediaAbaixoDe(int idTurma, double limite) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT a.id_aluno, AVG(n.valor) AS media_aluno
            FROM aluno a
            LEFT JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE a.id_turma = ?
            GROUP BY a.id_aluno
        ) x
        WHERE COALESCE(x.media_aluno, 0) < ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);
            stmt.setDouble(2, limite);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Erro ao contar alunos abaixo de: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Distribuição para o gráfico: arredonda a nota e conta quantas vezes apareceu.
     * Retorna map<nota_int, quantidade>
     */
    public Map<Integer, Integer> buscarDistribuicaoNotasArredondadas(int idTurma) {
        Map<Integer, Integer> map = new HashMap<>();

        String sql = """
        SELECT CAST(ROUND(COALESCE(media_aluno, 0)) AS INT) AS media_int,
               COUNT(*) AS qtd
        FROM (
            SELECT a.id_aluno,
                   AVG(n.valor) AS media_aluno
            FROM aluno a
            LEFT JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE a.id_turma = ?
            GROUP BY a.id_aluno
        ) x
        GROUP BY media_int
        ORDER BY media_int
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int mediaInt = rs.getInt("media_int");
                    int qtd = rs.getInt("qtd");

                    // garante que vai cair entre 1..10
                    if (mediaInt < 1) mediaInt = 1;
                    if (mediaInt > 10) mediaInt = 10;

                    map.put(mediaInt, map.getOrDefault(mediaInt, 0) + qtd);
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar distribuição (média por aluno): " + e.getMessage());
        }

        return map;
    }


    public List<Map<String, Object>> buscarRankingTop5(int idTurma) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT a.id_aluno, u.nome, ROUND(AVG(n.valor), 1) AS media
        FROM aluno a
        JOIN usuario u ON u.id_user = a.id_user
        LEFT JOIN nota n ON n.id_aluno = a.id_aluno
        WHERE a.id_turma = ?
        GROUP BY a.id_aluno, u.nome
        ORDER BY media DESC NULLS LAST
        LIMIT 5
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id_aluno", rs.getInt("id_aluno"));
                    m.put("nome", rs.getString("nome"));
                    double media = rs.getDouble("media");
                    m.put("media", rs.wasNull() ? 0.0 : media);
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar ranking: " + e.getMessage());
        }

        return list;
    }

    public List<Map<String, Object>> buscarRankingBottom5(int idTurma) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT a.id_aluno, u.nome, ROUND(AVG(n.valor), 1) AS media
        FROM aluno a
        JOIN usuario u ON u.id_user = a.id_user
        LEFT JOIN nota n ON n.id_aluno = a.id_aluno
        WHERE a.id_turma = ?
        GROUP BY a.id_aluno, u.nome
        ORDER BY COALESCE(ROUND(AVG(n.valor), 1), 0) ASC, u.nome ASC
        LIMIT 5
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id_aluno", rs.getInt("id_aluno"));
                    m.put("nome", rs.getString("nome"));
                    double media = rs.getDouble("media");
                    m.put("media", rs.wasNull() ? 0.0 : media);
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar ranking bottom5: " + e.getMessage());
        }

        return list;
    }

    public int contarObservacoesDaTurma(int idTurma) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        WHERE a.id_turma = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Erro ao contar observações: " + e.getMessage());
        }
        return 0;
    }
    public List<Map<String, Object>> buscarUltimasObservacoesDaTurma(int idTurma, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT u.nome, o.mensagem, o.data, o.tipo
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        JOIN usuario u ON u.id_user = a.id_user
        WHERE a.id_turma = ?
        ORDER BY o.data DESC, o.id_observacao DESC
        LIMIT ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("nome", rs.getString("nome"));
                    m.put("mensagem", rs.getString("mensagem"));
                    m.put("data", rs.getDate("data")); // Date
                    m.put("tipo", rs.getInt("tipo"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar últimas observações: " + e.getMessage());
        }

        return list;
    }

    public Map<String, Object> buscarAlunoTopObservacoes(int idTurma, int tipo) {
        String sql = """
    SELECT a.id_aluno, u.nome, u.foto, COUNT(*) AS total
    FROM observacao o
    JOIN aluno a ON a.id_aluno = o.id_aluno
    JOIN usuario u ON u.id_user = a.id_user
    WHERE a.id_turma = ? AND o.tipo = ?
    GROUP BY a.id_aluno, u.nome, u.foto
    ORDER BY total DESC
    LIMIT 1
""";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);
            stmt.setInt(2, tipo);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id_aluno", rs.getInt("id_aluno"));
                    m.put("nome", rs.getString("nome"));
                    m.put("total", rs.getInt("total"));
                    m.put("foto", rs.getString("foto"));
                    return m;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar top observações: " + e.getMessage());
        }
        return null;
    }


}