<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adm.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/indicador-adm.css">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/Group-558.ico">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <title>Alunos - Devant</title>
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
                        <a href="${pageContext.request.contextPath}/adm/perfil-adm.jsp" class="nav-link flex items-center gap-2 hover:opacity-80 text-[120%]">
                            Perfil
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/adm/turmas-adm.jsp" class="nav-link flex items-center gap-2 hover:opacity-80 text-[120%]">
                            Turmas
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/adm/alunos-adm.jsp"
                            class="nav-link ativo flex items-center gap-2 hover:opacity-80 text-[120%]">
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
    <main class="flex-1 p-4">
        <section>
            <h1 class="text-[#3a3a3a] font-semibold text-[220%] text-left mb-2">Alunos</h1>


            <div class="flex items-center gap-4 mb-6 justify-between">
                <div>
                    <div
                        class="h-9 inline-flex items-center gap-2 bg-[#ECF5FF] border border-[#274855] rounded-[10px] px-4 py-2 text-[#3a3a3a] font-semibold whitespace-nowrap">
                        <i data-feather="users" class="w-7 h-7 text-[#274855]"></i>
                        <span class="w-full block text-[80%]">Total Alunos: 1</span>
                    </div>
                    <button onclick="window.location.href='${pageContext.request.contextPath}/adm/adicionar-aluno.jsp'"
                        class="h-9 inline-flex items-center gap-2 bg-[#7F95AB] border border-[#274855] rounded-[10px] px-4 py-2 text-white font-semibold whitespace-nowrap hover:bg-[#667788] transition-all duration-200 ease-in-out">
                        <i data-feather="plus" class="w-7 h-7 text-white"></i>
                        <span class="w-full block text-[80%]">Adicionar Aluno</span>
                    </button>
                </div>
                <div class="flex justify-end items-center gap-2">

                    <div class="flex items-center border-2 border-[#274855] rounded-[10px] px-3 py-2 h-10 w-80">
                        <input type="text" placeholder="Pesquisar aluno"
                            class="flex-1 bg-transparent text-gray-700 placeholder-gray-400 focus:outline-none">

                        <button type="submit">
                            <i class="text-gray-500 hover:text-[#3C9D9B] cursor-pointer w-5 h-5"
                                data-feather="search"></i>
                        </button>
                    </div>


                </div>
            </div>


            <div class="bg-white rounded-lg shadow max-w-6xl mx-auto overflow-x-auto overflow-y-auto">

                <table class="w-full">
                    <thead>
                        <tr class="bg-[#7F95AB] text-[#274855]">
                            <th class="p-3 text-left">NOME</th>
                            <th class="p-3 text-center">MATRÍCULA</th>
                            <th class="p-3 text-center">TURMA</th>
                            <th class="p-3 text-center">E-MAIL</th>
                            <th class="p-3 text-center">SENHA</th>
                            <th class=" p-3 text-center">DESEMPENHO</th>
                            <th class="p-3 text-center">FOTO</th>
                            <th class=" p-3 text-center"></th>
                        </tr>
                    </thead>
                    <tbody id="corpo-tabela">
                        <tr class="bg-white">
                            <td class="px-2 py-1 border-b text-[100%] space-y-2 whitespace-nowrap">João Gomes da Silva
                            </td>
                            <td class="px-2 py-1 border-b text-[100%] space-y-2 text-center">1GT</td>
                            <td class="px-2 py-1 border-b text-[100%] text-center space-y-2">8° E.F. J</td>
                            <td class="px-2 py-1 border-b text-[100%] space-y-2 text-center">joao.gomes@devant.org.br
                            </td>
                            <td class="px-2 py-1 border-b text-[100%] space-y-2 text-center">baiaocomjaba</td>
                            <td
                                class="px-2 py-1 border-b text-[100%] font-semibold text-center space-y-2 text-[#F01C1C]">
                                <button id="botao-desempenho" onclick="abrirPopUpDes()"
                                    class="h-9 inline-flex items-center gap-2 bg-[#7F95AB] border border-[#274855] rounded-[20px] px-4 py-2 text-white font-semibold whitespace-nowrap hover:bg-[#667788] transition-all duration-200 ease-in-out">
                                    <i data-feather="award" class="w-7 h-7 text-white"></i>
                                    <span class="w-full block text-[80%]">Ver desempenho</span>
                                </button>
                            </td>
                            <td
                                class="px-2 py-1 border-b text-[100%] space-y-2 font-semibold text-center text-[#3088E5]">
                                <button id="botao-foto" onclick="abrirFoto()"
                                    class="h-9 inline-flex items-center gap-2 bg-[#7F95AB] border border-[#274855] rounded-[20px] px-4 py-2 text-white font-semibold whitespace-nowrap hover:bg-[#667788] transition-all duration-200 ease-in-out">
                                    <i data-feather="crop" class="w-7 h-7 text-white"></i>
                                    <span class="w-full block text-[80%]">Ver foto</span>
                                </button>
                            </td>
                            <td class="px-2 py-1 border-b text-xs">
                                <div class="flex space-x-2 justify-end"
                                    onclick="window.location.href='${pageContext.request.contextPath}/adm/alterar-aluno.jsp'">
                                    <button class="p-1 text-blue-600 hover:text-blue-800">
                                        <i data-feather="edit" class="w-4 h-4"></i>
                                    </button>
                                    <button class="p-1 text-red-600 hover:text-red-800" onclick="">
                                        <i data-feather="trash-2" class="w-4 h-4"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
        </section>

        <!-- POPUP DESEMPENHO-->
        <div id="popup-desempenho"
            class="fixed inset-0 bg-black/40 flex items-center justify-center overflow-x-auto overflow-y-auto hidden">

            <div class="bg-white rounded-lg shadow max-w-[60%] w-full relative p-4">
                <button onclick="fecharPopUpDes()" class="absolute top-3 right-3 text-gray-600 hover:text-red-600">
                    ✖
                </button>

                <table class="w-full">
                    <thead>
                        <tr class="text-black">
                            <th class="p-3 text-left">DISCIPLINA</th>
                            <th class="p-3 text-center">NOTA 1</th>
                            <th class="p-3 text-center">NOTA 2</th>
                            <th class="p-3 text-center">MÉDIA</th>
                            <th class="p-3 text-center">RESULTADO</th>
                            <th class=" p-3 text-center"></th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr>
                            <td class="p-2 border-b">Desenvolvimento</td>
                            <td class="p-2 border-b text-center font-semibold text-[#F01C1C]">4.5</td>
                            <td class="p-2 border-b text-center font-semibold text-[#3088E5]">9.7</td>
                            <td class="p-2 border-b text-center font-semibold text-[#3088E5]">7.1</td>
                            <td class="p-2 border-b text-center font-semibold text-[#3088E5]">APROVADO</td>
                            <td class="px-2 py-1 border-b text-xs">
                                <div class="flex space-x-2 justify-end"
                                    onclick="window.location.href='${pageContext.request.contextPath}/adm/alterar-nota-adm.jsp'">
                                    <button class="p-1 text-blue-600 hover:text-blue-800">
                                        <i data-feather="edit" class="w-4 h-4"></i>
                                    </button>
                                    <button class="p-1 text-red-600 hover:text-red-800" onclick="">
                                        <i data-feather="trash-2" class="w-4 h-4"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>

                </table>

            </div>
        </div>

        <!-- POPUP FOTO -->
        <div id="popup-foto" onclick="fecharFoto()"
            class="fixed inset-0 bg-black/40 flex items-center justify-center hidden">

            <button onclick="fecharFoto()"
                class="absolute top-2 right-2 text-gray-600 hover:text-red-600 text-xl font-bold">
                ✕
            </button>

            <img src="${pageContext.request.contextPath}/assets/perfil-adm.jpg" alt="Foto aluno" class="max-w-[80vh] max-h-[80vh] w-full rounded">

        </div>
        </div>
    </main>
    <script>
        feather.replace();
    </script>
    <script src="${pageContext.request.contextPath}/js/indicador-aba.js"></script>
    <script src="${pageContext.request.contextPath}/js/desempenho.js"></script>
    <script src="${pageContext.request.contextPath}/js/foto.js"></script>
</body>

</html>