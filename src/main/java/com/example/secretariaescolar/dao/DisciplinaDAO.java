package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Observacao;
import com.example.secretariaescolar.util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DisciplinaDAO {

    // Buscar disciplina por ID
    public Disciplina buscarPorId(int id) {
        String sql = "SELECT id_disciplina, nome FROM disciplina WHERE id_disciplina = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    return d;
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar a disciplina pelo ID: " + e.getMessage());
        }

        return null;
    }

    public Disciplina buscarPorNome(String nome) {
        String sql = "SELECT id_disciplina, nome FROM disciplina WHERE LOWER(nome) = LOWER(?)";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    return d;
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar a disciplina pelo nome: " + e.getMessage());
        }

        return null;
    }

    // Listar todas as disciplinas
    public List<Disciplina> listarTodas() {
        List<Disciplina> disciplinas = new ArrayList<>();
        String sql = "SELECT id_disciplina, nome FROM disciplina ORDER BY nome";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Disciplina d = new Disciplina();
                d.setId_disciplina(rs.getInt("id_disciplina"));
                d.setNome(rs.getString("nome"));
                disciplinas.add(d);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao listar as disciplinas: " + e.getMessage());
        }

        return disciplinas;
    }

    public Disciplina buscarDisciplinaDoProfessorPorIdUser(int idUserProfessor) {
        String sql = """
            SELECT d.id_disciplina, d.nome
            FROM professor p
            JOIN disciplina d ON d.id_disciplina = p.id_disciplina
            WHERE p.id_user = ?
            LIMIT 1
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUserProfessor);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    return d;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Disciplina> listarOutrasDisciplinasDoProfessorPorIdUser(int idUserProfessor) {
        List<Disciplina> lista = new ArrayList<>();

        String sql = """
            SELECT d.id_disciplina, d.nome
            FROM disciplina d
            WHERE d.id_disciplina <>
                (SELECT p.id_disciplina
                 FROM professor p
                 WHERE p.id_user = ?
                 LIMIT 1)
            ORDER BY d.nome ASC
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUserProfessor);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    lista.add(d);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public int contarAlunosPorDisciplina(int idDisciplina) {
        String sql = """
        SELECT COUNT(DISTINCT a.id_aluno) AS total
        FROM aluno a
        JOIN nota n ON n.id_aluno = a.id_aluno
        WHERE n.id_disciplina = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarAlunosPorDisciplinaETurma(int idDisciplina, int idTurma) {
        String sql = """
        SELECT COUNT(DISTINCT a.id_aluno) AS total
        FROM aluno a
        JOIN nota n ON n.id_aluno = a.id_aluno
        WHERE n.id_disciplina = ?
          AND a.id_turma = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarAlunosPorDisciplinaESerie(int idDisciplina, int serie) {
        String sql = """
        SELECT COUNT(DISTINCT a.id_aluno) AS total
        FROM aluno a
        JOIN turma t ON t.id_turma = a.id_turma
        JOIN nota n ON n.id_aluno = a.id_aluno
        WHERE n.id_disciplina = ?
          AND t.nome LIKE ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setString(2, serie + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public double buscarMediaDisciplina(int idDisciplina) {
        String sql = """
        SELECT ROUND(AVG(n.valor), 1) AS media
        FROM nota n
        WHERE n.id_disciplina = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double v = rs.getDouble("media");
                    return rs.wasNull() ? 0.0 : v;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    public double buscarMediaDisciplinaETurma(int idDisciplina, int idTurma) {
        String sql = """
        SELECT ROUND(AVG(n.valor), 1) AS media
        FROM nota n
        JOIN aluno a ON a.id_aluno = n.id_aluno
        WHERE n.id_disciplina = ?
          AND a.id_turma = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double v = rs.getDouble("media");
                    return rs.wasNull() ? 0.0 : v;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    public double buscarMediaDisciplinaESerie(int idDisciplina, int serie) {
        String sql = """
        SELECT ROUND(AVG(n.valor), 1) AS media
        FROM nota n
        JOIN aluno a ON a.id_aluno = n.id_aluno
        JOIN turma t ON t.id_turma = a.id_turma
        WHERE n.id_disciplina = ?
          AND t.nome LIKE ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setString(2, serie + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double v = rs.getDouble("media");
                    return rs.wasNull() ? 0.0 : v;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    public int contarAlunosComMediaAcimaOuIgual7NaDisciplina(int idDisciplina) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT a.id_aluno, AVG(n.valor) AS media_aluno
            FROM aluno a
            JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE n.id_disciplina = ?
            GROUP BY a.id_aluno
        ) x
        WHERE COALESCE(x.media_aluno, 0) >= 7
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarAlunosComMediaAbaixo7NaDisciplina(int idDisciplina) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT a.id_aluno, AVG(n.valor) AS media_aluno
            FROM aluno a
            JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE n.id_disciplina = ?
            GROUP BY a.id_aluno
        ) x
        WHERE COALESCE(x.media_aluno, 0) < 7
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarAlunosComMediaAcimaOuIgual7NaDisciplinaETurma(int idDisciplina, int idTurma) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT a.id_aluno, AVG(n.valor) AS media_aluno
            FROM aluno a
            JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE n.id_disciplina = ?
              AND a.id_turma = ?
            GROUP BY a.id_aluno
        ) x
        WHERE COALESCE(x.media_aluno, 0) >= 7
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarAlunosComMediaAbaixo7NaDisciplinaETurma(int idDisciplina, int idTurma) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT a.id_aluno, AVG(n.valor) AS media_aluno
            FROM aluno a
            JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE n.id_disciplina = ?
              AND a.id_turma = ?
            GROUP BY a.id_aluno
        ) x
        WHERE COALESCE(x.media_aluno, 0) < 7
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarAlunosComMediaAcimaOuIgual7NaDisciplinaESerie(int idDisciplina, int serie) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT a.id_aluno, AVG(n.valor) AS media_aluno
            FROM aluno a
            JOIN turma t ON t.id_turma = a.id_turma
            JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE n.id_disciplina = ?
              AND t.nome LIKE ?
            GROUP BY a.id_aluno
        ) x
        WHERE COALESCE(x.media_aluno, 0) >= 7
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setString(2, serie + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarAlunosComMediaAbaixo7NaDisciplinaESerie(int idDisciplina, int serie) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM (
            SELECT a.id_aluno, AVG(n.valor) AS media_aluno
            FROM aluno a
            JOIN turma t ON t.id_turma = a.id_turma
            JOIN nota n ON n.id_aluno = a.id_aluno
            WHERE n.id_disciplina = ?
              AND t.nome LIKE ?
            GROUP BY a.id_aluno
        ) x
        WHERE COALESCE(x.media_aluno, 0) < 7
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setString(2, serie + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Map<String, Object>> buscarRankingTop5Disciplina(int idDisciplina) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT a.id_aluno, u.nome, ROUND(AVG(n.valor), 1) AS media
        FROM aluno a
        JOIN usuario u ON u.id_user = a.id_user
        JOIN nota n ON n.id_aluno = a.id_aluno
        WHERE n.id_disciplina = ?
        GROUP BY a.id_aluno, u.nome
        ORDER BY media DESC NULLS LAST
        LIMIT 5
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id_aluno", rs.getInt("id_aluno"));
                    m.put("nome", rs.getString("nome"));
                    m.put("media", rs.getDouble("media"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Map<String, Object>> buscarRankingTop5DisciplinaETurma(int idDisciplina, int idTurma) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT a.id_aluno, u.nome, ROUND(AVG(n.valor), 1) AS media
        FROM aluno a
        JOIN usuario u ON u.id_user = a.id_user
        JOIN nota n ON n.id_aluno = a.id_aluno
        WHERE n.id_disciplina = ?
          AND a.id_turma = ?
        GROUP BY a.id_aluno, u.nome
        ORDER BY media DESC NULLS LAST
        LIMIT 5
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id_aluno", rs.getInt("id_aluno"));
                    m.put("nome", rs.getString("nome"));
                    m.put("media", rs.getDouble("media"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Map<String, Object>> buscarRankingTop5DisciplinaESerie(int idDisciplina, int serie) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT a.id_aluno, u.nome, ROUND(AVG(n.valor), 1) AS media
        FROM aluno a
        JOIN usuario u ON u.id_user = a.id_user
        JOIN turma t ON t.id_turma = a.id_turma
        JOIN nota n ON n.id_aluno = a.id_aluno
        WHERE n.id_disciplina = ?
          AND t.nome LIKE ?
        GROUP BY a.id_aluno, u.nome
        ORDER BY media DESC NULLS LAST
        LIMIT 5
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setString(2, serie + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id_aluno", rs.getInt("id_aluno"));
                    m.put("nome", rs.getString("nome"));
                    m.put("media", rs.getDouble("media"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int contarObservacoesDaDisciplina(int idDisciplina) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM observacao
        WHERE id_disciplina = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarObservacoesDaDisciplinaETurma(int idDisciplina, int idTurma) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        WHERE o.id_disciplina = ?
          AND a.id_turma = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarObservacoesDaDisciplinaESerie(int idDisciplina, int serie) {
        String sql = """
        SELECT COUNT(*) AS total
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        JOIN turma t ON t.id_turma = a.id_turma
        WHERE o.id_disciplina = ?
          AND t.nome LIKE ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setString(2, serie + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Map<String, Object>> buscarUltimasObservacoesDaDisciplina(int idDisciplina, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT u_aluno.nome AS nome,
               o.mensagem,
               o.tipo,
               o.data,
               u_prof.nome AS nome_professor
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        JOIN usuario u_aluno ON u_aluno.id_user = a.id_user
        JOIN professor p ON p.id_professor = o.id_professor
        JOIN usuario u_prof ON u_prof.id_user = p.id_user
        WHERE o.id_disciplina = ?
        ORDER BY o.data DESC, o.id_observacao DESC
        LIMIT ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("nome", rs.getString("nome"));
                    m.put("mensagem", rs.getString("mensagem"));
                    m.put("data", rs.getDate("data"));
                    m.put("tipo", rs.getInt("tipo"));
                    m.put("nome_professor", rs.getString("nome_professor"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Map<String, Object>> buscarUltimasObservacoesDaDisciplinaETurma(int idDisciplina, int idTurma, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT u_aluno.nome AS nome,
               o.mensagem,
               o.tipo,
               o.data,
               u_prof.nome AS nome_professor
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        JOIN usuario u_aluno ON u_aluno.id_user = a.id_user
        JOIN professor p ON p.id_professor = o.id_professor
        JOIN usuario u_prof ON u_prof.id_user = p.id_user
        WHERE o.id_disciplina = ?
          AND a.id_turma = ?
        ORDER BY o.data DESC, o.id_observacao DESC
        LIMIT ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, idTurma);
            stmt.setInt(3, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("nome", rs.getString("nome"));
                    m.put("mensagem", rs.getString("mensagem"));
                    m.put("data", rs.getDate("data"));
                    m.put("tipo", rs.getInt("tipo"));
                    m.put("nome_professor", rs.getString("nome_professor"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Map<String, Object>> buscarUltimasObservacoesDaDisciplinaESerie(int idDisciplina, int serie, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT u_aluno.nome AS nome,
               o.mensagem,
               o.tipo,
               o.data,
               u_prof.nome AS nome_professor
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        JOIN turma t ON t.id_turma = a.id_turma
        JOIN usuario u_aluno ON u_aluno.id_user = a.id_user
        JOIN professor p ON p.id_professor = o.id_professor
        JOIN usuario u_prof ON u_prof.id_user = p.id_user
        WHERE o.id_disciplina = ?
          AND t.nome LIKE ?
        ORDER BY o.data DESC, o.id_observacao DESC
        LIMIT ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setString(2, serie + "%");
            stmt.setInt(3, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("nome", rs.getString("nome"));
                    m.put("mensagem", rs.getString("mensagem"));
                    m.put("data", rs.getDate("data"));
                    m.put("tipo", rs.getInt("tipo"));
                    m.put("nome_professor", rs.getString("nome_professor"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Map<String, Object> buscarAlunoTopObservacoesDisciplina(int idDisciplina, int tipo) {
        String sql = """
        SELECT a.id_aluno, u.nome, u.foto, COUNT(*) AS total
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        JOIN usuario u ON u.id_user = a.id_user
        WHERE o.id_disciplina = ?
          AND o.tipo = ?
        GROUP BY a.id_aluno, u.nome, u.foto
        ORDER BY total DESC
        LIMIT 1
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
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
            e.printStackTrace();
        }

        return null;
    }

    public Map<String, Object> buscarAlunoTopObservacoesDisciplinaETurma(int idDisciplina, int idTurma, int tipo) {
        String sql = """
        SELECT a.id_aluno, u.nome, u.foto, COUNT(*) AS total
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        JOIN usuario u ON u.id_user = a.id_user
        WHERE o.id_disciplina = ?
          AND a.id_turma = ?
          AND o.tipo = ?
        GROUP BY a.id_aluno, u.nome, u.foto
        ORDER BY total DESC
        LIMIT 1
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setInt(2, idTurma);
            stmt.setInt(3, tipo);

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
            e.printStackTrace();
        }

        return null;
    }

    public Map<String, Object> buscarAlunoTopObservacoesDisciplinaESerie(int idDisciplina, int serie, int tipo) {
        String sql = """
        SELECT a.id_aluno, u.nome, u.foto, COUNT(*) AS total
        FROM observacao o
        JOIN aluno a ON a.id_aluno = o.id_aluno
        JOIN turma t ON t.id_turma = a.id_turma
        JOIN usuario u ON u.id_user = a.id_user
        WHERE o.id_disciplina = ?
          AND t.nome LIKE ?
          AND o.tipo = ?
        GROUP BY a.id_aluno, u.nome, u.foto
        ORDER BY total DESC
        LIMIT 1
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            stmt.setString(2, serie + "%");
            stmt.setInt(3, tipo);

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
            e.printStackTrace();
        }

        return null;
    }

    public List<Observacao> listarPorAlunoEDisciplina(int idAluno, int idDisciplina) {
        List<Observacao> lista = new ArrayList<>();

        String sql = """
        SELECT 
            o.id_observacao,
            o.mensagem,
            o.data,
            o.id_aluno,
            o.id_professor,
            o.id_disciplina,
            o.tipo,
            u.nome AS nome_professor
        FROM observacao o
        INNER JOIN professor p ON p.id_professor = o.id_professor
        INNER JOIN usuario u ON u.id_user = p.id_user
        WHERE o.id_aluno = ? AND o.id_disciplina = ?
        ORDER BY o.data DESC, o.id_observacao DESC
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setInt(2, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Observacao o = new Observacao();
                    o.setId_observacao(rs.getInt("id_observacao"));
                    o.setMensagem(rs.getString("mensagem"));
                    o.setData(rs.getDate("data").toLocalDate());
                    o.setId_aluno(rs.getInt("id_aluno"));
                    o.setId_professor(rs.getInt("id_professor"));
                    o.setId_disciplina(rs.getInt("id_disciplina"));
                    o.setTipo(rs.getInt("tipo"));
                    o.setNomeProfessor(rs.getString("nome_professor"));

                    lista.add(o);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}