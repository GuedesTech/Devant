${pageContext.request.contextPath}/<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adm.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/indicador-adm.css">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/Group-558.ico">
    <script src=" https://cdn.tailwindcss.com">
    </script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <title>Perfil - Devant</title>
</head>

<body class="bg-[#EDEFEF]">
    <header class="text-white shadow-md">
        <div class="max-w-7xl mx-auto px-0 py-3 flex items-center">
            <div class="flex-1" style="margin-left: -50px; margin-right: 40px;">
                <a href="${pageContext.request.contextPath}/adm/perfil-adm.jsp">
                    <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo" class="h-9">
                </a>
            </div>

            <nav class="nav flex-1 flex justify-center mb-[-1%]">
                <ul class="flex gap-12 items-center">
                    <li>
                        <a href="${pageContext.request.contextPath}/adm/perfil-adm.jsp"
                            class="nav-link ativo flex items-center gap-2 hover:opacity-80 text-[120%]">
                            Perfil
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adm/turmas-adm.jsp" class="nav-link flex items-center gap-2 hover:opacity-80 text-[120%]">
                            Turmas
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/adm/alunos-adm.jsp" class="nav-link flex items-center gap-2 hover:opacity-80 text-[120%]">
                            Alunos
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adm/professores-adm.jsp"
                            class="nav-link flex items-center gap-2 hover:opacity-80 text-[120%]">
                            Professores
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adm/matérias-adm.jsp"
                            class="nav-link flex items-center gap-2 hover:opacity-80 text-[120%]">
                            Disciplinas
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/adm/observacoes-adm.jsp"
                            class="nav-link flex items-center gap-2 hover:opacity-80 text-[120%]">
                            Observações
                        </a>
                    </li>
                </ul>
                <div class="indicador"></div>
            </nav>

            <div class="flex-1 flex justify-end">
                <a href="${pageContext.request.contextPath}/index.jsp"
                    class="flex items-center gap-2 bg-tranparent border-2 border-white text-white font-semibold px-4 py-2 rounded-[20px] hover:bg-[#F01C1C] hover:text-white transition">
                    <i data-feather="log-out"></i> Sair
                </a>
            </div>

        </div>
    </header>
    <main class="flex justify-center mt-24 px-4">
        <div class="bg-white rounded-2xl shadow-xl p-12 flex justify-between items-center w-full max-w-3xl">
            <div class="space-y-4">
                <h1 class="text-xs font-bold text-[#274855] uppercase text-[200%] mb-[-10px]">Perfil</h1>
                <div>
                    <h2 class="text-4xl font-semibold text-gray-900">Tadala Fellas</h2>
                        <p class="text-gray-400 font-semibold text-lg">Administrador</p>
                </div>

                <div class="space-y-2">
                    <div>
                        <p class="text-gray-500 font-medium text-sm">Email:</p>
                        <p class="text-gray-800">tadala@devant.org.br</p>
                    </div>
                    <div>
                        <p class="text-gray-500 font-medium text-sm">Senha:</p>
                        <p class="text-gray-800">sougangster</p>
                    </div>
                </div>
            </div>

            <img src="assets/perfil-adm.jpg" alt="Foto de Perfil"
                class="w-48 h-48 rounded-full object-cover border-4 border-gray-100 shadow-sm">
        </div>
    </main>
    <script>
        feather.replace();
    </script>
    <script src="${pageContext.request.contextPath}/js/indicador-aba.js">
    </script>
</body>

</html>