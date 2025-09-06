const projects = [
  { name: 'Project Alpha', description: 'First project placeholder', link: '#' },
  { name: 'Project Beta', description: 'Another project placeholder', link: '#' },
  { name: 'Project Gamma', description: 'Yet another project placeholder', link: '#' }
];

const tbody = document.getElementById('projects-body');

projects.forEach(p => {
  const tr = document.createElement('tr');
  tr.innerHTML = `<td><a href="${p.link}" target="_blank" rel="noopener noreferrer">${p.name}</a></td><td>${p.description}</td>`;
  tbody.appendChild(tr);
});

document.getElementById('footer-text').textContent = `© ${new Date().getFullYear()} Jürgen Mathes`;
