function moverIndicador() {
    const nav = document.querySelector(".topbar-nav");
    const indicador = document.querySelector(".nav-indicador");
    const ativo = document.querySelector(".topbar-link.is-active");

    if (!nav || !indicador || !ativo) return;

    const rect = ativo.getBoundingClientRect();
    const navRect = nav.getBoundingClientRect();

    indicador.style.width = rect.width + "px";
    indicador.style.left = (rect.left - navRect.left) + "px";
}

window.addEventListener("load", moverIndicador);
window.addEventListener("resize", moverIndicador);

document.addEventListener("DOMContentLoaded", () => {
    const links = document.querySelectorAll(".topbar-link");
    links.forEach(link => {
        link.addEventListener("click", () => {
            links.forEach(l => l.classList.remove("is-active"));
            link.classList.add("is-active");
            moverIndicador();
        });
    });
});