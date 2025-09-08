const projects = [
  {
    name: "Tiny Pathformer",
    description: "Autoregressive gridworld IL->RL sandbox (with rollouts).",
    link: "https://github.dev/juergenmathes/tiny-pathformer",
    gif: "https://raw.githubusercontent.com/juergenmathes/tiny-pathformer/main/videos/best_ep40_ok.gif"
  }
];

const tbody = document.getElementById("projects-body");

projects.forEach(proj => {
  const row = document.createElement("tr");

  const tdName = document.createElement("td");
  const a = document.createElement("a");
  a.href = proj.link;
  a.textContent = proj.name;
  tdName.appendChild(a);

  const tdDesc = document.createElement("td");
  tdDesc.textContent = proj.description;

  row.appendChild(tdName);
  row.appendChild(tdDesc);
  tbody.appendChild(row);

  // GIF row
  if (proj.gif) {
    const gifRow = document.createElement("tr");
    const gifCell = document.createElement("td");
    gifCell.colSpan = 2;

    const img = document.createElement("img");
    img.src = proj.gif;
    img.alt = proj.name + " preview";
    img.style.maxWidth = "100%";
    img.style.border = "1px solid #ccc";
    img.style.margin = "0.5rem 0";

    gifCell.appendChild(img);
    gifRow.appendChild(gifCell);
    tbody.appendChild(gifRow);
  }
});
