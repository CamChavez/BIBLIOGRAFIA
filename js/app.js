// ═══════════════════════════════════════════════════════════════
//   CRUD de Referencias Bibliográficas
//   Cliente JS — habla con la API REST en /api/*.php
// ═══════════════════════════════════════════════════════════════

const API = 'api';

// ── Estado global ─────────────────────────────────────────────
const state = {
    view:          'materias',
    semestre:      'all',
    tipoBiblio:    '',
    semestres:     [],
    materiaActiva: null,
    citaActual:    null,
    autorActivo:   null,
    searchTerm:    '',
};

// ═══════════════════════════════════════════════════════════════
//  HELPERS
// ═══════════════════════════════════════════════════════════════
const $  = (sel, root = document) => root.querySelector(sel);
const $$ = (sel, root = document) => [...root.querySelectorAll(sel)];

const esc = s =>
    String(s ?? '').replace(/[&<>"']/g, m =>
        ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));

// ── HTTP ──────────────────────────────────────────────────────
const api = {
    async _go(method, url, body) {
        const opts = { method, headers: {} };
        if (body !== undefined) {
            opts.headers['Content-Type'] = 'application/json';
            opts.body = JSON.stringify(body);
        }
        const res  = await fetch(url, opts);
        const data = await res.json().catch(() => ({}));
        if (!res.ok) throw new Error(data.error || data.detalle || `HTTP ${res.status}`);
        return data;
    },
    get (url)       { return this._go('GET',    url); },
    post(url, body) { return this._go('POST',   url, body); },
    put (url, body) { return this._go('PUT',    url, body); },
    del (url)       { return this._go('DELETE', url); },
};

// ── Toast ─────────────────────────────────────────────────────
function toast(msg, type = 'success') {
    const icons = { success: '✓', error: '✕', info: 'ℹ' };
    const el = document.createElement('div');
    el.className = `toast toast--${type}`;
    el.innerHTML = `<span class="toast__icon">${icons[type] ?? 'ℹ'}</span><span>${esc(msg)}</span>`;
    $('#toastStack').appendChild(el);
    setTimeout(() => {
        el.style.cssText = 'transition:opacity .25s,transform .25s;opacity:0;transform:translateX(20px)';
        setTimeout(() => el.remove(), 280);
    }, 2800);
}

// ── Modales ───────────────────────────────────────────────────
const openModal  = id => { $(`#${id}`).setAttribute('aria-hidden','false'); document.body.style.overflow = 'hidden'; };
const closeModal = id => { $(`#${id}`).setAttribute('aria-hidden','true');  document.body.style.overflow = ''; };
const closeAll   = ()  => { $$('.modal').forEach(m => m.setAttribute('aria-hidden','true')); document.body.style.overflow = ''; };

// ═══════════════════════════════════════════════════════════════
//  INIT
// ═══════════════════════════════════════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
    bindUI();
    await loadSemestres();
    await loadMaterias();
});

function bindUI() {
    // Tabs principales
    $$('.tab').forEach(t => t.addEventListener('click', () => switchView(t.dataset.view)));

    // Nueva materia
    $('#btnAddMateria').addEventListener('click', abrirNuevaMateria);

    // Chips tipo bibliografía
    $$('.chip').forEach(c => c.addEventListener('click', () => {
        $$('.chip').forEach(x => x.classList.remove('chip--active'));
        c.classList.add('chip--active');
        state.tipoBiblio = c.dataset.tipo || '';
        loadBibliografias();
    }));

    // Botones volver
    $('#btnBackToList').addEventListener('click',   () => switchView('materias'));
    $('#btnBackFromAutor').addEventListener('click', () => switchView('autores'));

    // Búsqueda global
    let timer;
    $('#searchInput').addEventListener('input', e => {
        clearTimeout(timer);
        timer = setTimeout(() => {
            state.searchTerm = e.target.value.trim();
            // Siempre ir a la vista de bibliografías al buscar
            if (state.view !== 'bibliografias') {
                switchView('bibliografias');
            } else {
                loadBibliografias();
            }
        }, 300);
    });

    // Cerrar modales
    document.addEventListener('click', e => { if (e.target.matches('[data-close]')) closeAll(); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') closeAll(); });

    // Forms
    $('#formMateria').addEventListener('submit', submitMateria);
    $('#formBibliografia').addEventListener('submit', submitBibliografia);

    // Mostrar/ocultar campos de artículo
    $('#formBibliografia [name="tipo_recurso"]').addEventListener('change', e => {
        $('.article-fields').classList.toggle('show', e.target.value === 'articulo');
    });

    // Tabs de formato de cita
    $$('.format-tab').forEach(t => t.addEventListener('click', () => {
        $$('.format-tab').forEach(x => x.classList.remove('format-tab--active'));
        t.classList.add('format-tab--active');
        renderCita(t.dataset.format);
    }));

    $('#btnCopyCita').addEventListener('click', copiarCita);
    $('#btnAddAutor').addEventListener('click', () => agregarAutorInput());
}

// ═══════════════════════════════════════════════════════════════
//  SEMESTRES
// ═══════════════════════════════════════════════════════════════
async function loadSemestres() {
    try {
        state.semestres = await api.get(`${API}/semestres.php`);
        renderSidebarSemestres();
    } catch (e) {
        toast('No se pudieron cargar los semestres: ' + e.message, 'error');
    }
}

function renderSidebarSemestres() {
    const ul = $('#semList');
    const normales  = state.semestres.filter(s => s.numero !== null);
    const optativas = state.semestres.find(s => s.numero === null);

    let items = normales.map(s => `
        <li class="sem-item" data-sem="${s.id}">
            <span class="sem-num">${s.numero}</span>
            ${esc(s.nombre)}
        </li>`).join('');

    if (optativas) {
        items += `
        <li class="sem-item" data-sem="${optativas.id}" style="margin-top:8px;border-top:1px dashed var(--border);padding-top:8px">
            <span class="sem-num">✦</span>
            ${esc(optativas.nombre)}
        </li>`;
    }

    ul.innerHTML = `
        <li class="sem-item sem-item--active" data-sem="all">
            <span class="sem-num">✦</span> Todos
        </li>${items}`;

    $$('.sem-item', ul).forEach(li => {
        li.addEventListener('click', () => {
            $$('.sem-item', ul).forEach(x => x.classList.remove('sem-item--active'));
            li.classList.add('sem-item--active');
            state.semestre = li.dataset.sem;
            if (state.view === 'materias' || state.view === 'detalle-materia') {
                switchView('materias');
            }
        });
    });
}

// ═══════════════════════════════════════════════════════════════
//  VISTAS
// ═══════════════════════════════════════════════════════════════
function switchView(view) {
    state.view = view;

    // Actualizar tabs (solo las vistas con tab real)
    const tabViews = ['materias', 'bibliografias', 'autores'];
    $$('.tab').forEach(t => t.classList.toggle('tab--active', t.dataset.view === view));

    // Mostrar panel correcto
    $$('.view').forEach(v => v.classList.remove('view--active'));
    const target = $(`#view-${view}`);
    if (target) target.classList.add('view--active');

    // Cargar datos según vista
    if (view === 'materias')      loadMaterias();
    if (view === 'bibliografias') loadBibliografias();
    if (view === 'autores')       loadAutores();
}

// ═══════════════════════════════════════════════════════════════
//  MATERIAS
// ═══════════════════════════════════════════════════════════════
async function loadMaterias() {
    const grid = $('#materiasGrid');
    grid.innerHTML = '<div class="loading">Cargando materias…</div>';
    try {
        const url = state.semestre === 'all'
            ? `${API}/materias.php`
            : `${API}/materias.php?semestre_id=${state.semestre}`;
        const materias = await api.get(url);
        if (!materias.length) {
            grid.innerHTML = `
                <div class="empty" style="grid-column:1/-1">
                    <div class="empty__icon">📚</div>
                    <p>Aún no hay materias${state.semestre !== 'all' ? ' en este semestre' : ''}.</p>
                    <button class="btn btn--primary btn--small" onclick="abrirNuevaMateria()">+ Crear la primera</button>
                </div>`;
            return;
        }
        grid.innerHTML = materias.map(materiaCardHtml).join('');
        $$('.materia-card', grid).forEach(card => {
            card.addEventListener('click', () => abrirDetalleMateria(+card.dataset.id));
        });
    } catch (e) {
        grid.innerHTML = `<div class="empty"><div class="empty__icon">😖</div><p>${esc(e.message)}</p></div>`;
    }
}

function materiaCardHtml(m) {
    const semLabel = m.semestre_numero ? `${m.semestre_numero}° Sem.` : (m.semestre_nombre || '');
    return `
    <div class="materia-card" data-id="${m.id}">
        <span class="materia-card__semestre">${esc(semLabel)}</span>
        <h3 class="materia-card__nombre">${esc(m.nombre)}</h3>
        <div class="materia-card__meta">
            ${m.creditos != null ? `<span>🎓 ${m.creditos} créditos</span>` : ''}
            ${m.area     ? `<span>📐 ${esc(m.area)}</span>` : ''}
            ${m.caracter ? `<span>${m.caracter==='Obligatorio'?'🟣':'⚪'} ${esc(m.caracter)}</span>` : ''}
        </div>
        ${+m.num_bibliografias > 0
            ? `<div class="materia-card__badge">📑 ${m.num_bibliografias} ${+m.num_bibliografias===1?'referencia':'referencias'}</div>`
            : `<div class="materia-card__badge" style="background:#FDEBEB;color:#A05050">📑 sin referencias</div>`}
    </div>`;
}

// ─── Detalle de materia ───────────────────────────────────────
async function abrirDetalleMateria(id) {
    state.materiaActiva = id;
    // Activar panel de detalle sin cambiar el tab activo
    $$('.view').forEach(v => v.classList.remove('view--active'));
    $('#view-detalle-materia').classList.add('view--active');
    state.view = 'detalle-materia';

    const cont = $('#detalleMateria');
    cont.innerHTML = '<div class="loading">Cargando detalle…</div>';
    try {
        const m = await api.get(`${API}/materias.php?id=${id}`);
        cont.innerHTML = detalleMateriaHtml(m);
        $('#btnEditMateria').addEventListener('click',   () => abrirEditarMateria(m));
        $('#btnDeleteMateria').addEventListener('click', () => confirmarBorrarMateria(m));
        $('#btnAddBibliografia').addEventListener('click', () => abrirNuevaBibliografia(m.id));
        attachBiblioActions(cont, () => abrirDetalleMateria(id));
    } catch (e) {
        cont.innerHTML = `<div class="empty"><div class="empty__icon">😖</div><p>${esc(e.message)}</p></div>`;
    }
}

function detalleMateriaHtml(m) {
    const basicas = (m.bibliografias || []).filter(b => b.tipo === 'basica');
    const compl   = (m.bibliografias || []).filter(b => b.tipo === 'complementaria');
    const semLabel = m.semestre_numero ? `${m.semestre_numero}° semestre` : (m.semestre_nombre || '');
    return `
    <div class="materia-detalle">
        <div class="materia-detalle__head">
            <div>
                <span class="tag">${esc(semLabel)}</span>
                <h2 class="materia-detalle__title">${esc(m.nombre)}</h2>
                <div class="materia-detalle__tags">
                    ${m.creditos  != null ? `<span class="tag tag--cream">🎓 ${m.creditos} créditos</span>` : ''}
                    ${m.area      ? `<span class="tag tag--cream">📐 ${esc(m.area)}</span>` : ''}
                    ${m.modalidad ? `<span class="tag tag--cream">${esc(m.modalidad)}</span>` : ''}
                    ${m.tipo      ? `<span class="tag tag--cream">${esc(m.tipo)}</span>` : ''}
                    ${m.caracter  ? `<span class="tag">${esc(m.caracter)}</span>` : ''}
                </div>
            </div>
            <div style="display:flex;gap:6px;flex-shrink:0">
                <button class="btn btn--secondary btn--small" id="btnEditMateria">✏️ Editar</button>
                <button class="btn btn--small" style="background:#FDEBEB;color:#A05050" id="btnDeleteMateria">🗑️</button>
            </div>
        </div>

        ${m.objetivo ? `
        <div class="materia-detalle__objetivo">
            <strong>Objetivo general:</strong> ${esc(m.objetivo)}
        </div>` : ''}

        ${(m.asignatura_antecedente || m.asignatura_subsecuente) ? `
        <div style="display:flex;gap:18px;flex-wrap:wrap;margin-bottom:16px;font-size:13px;color:var(--muted)">
            ${m.asignatura_antecedente ? `<span>⬅️ Antecedente: <strong style="color:var(--ink)">${esc(m.asignatura_antecedente)}</strong></span>` : ''}
            ${m.asignatura_subsecuente ? `<span>➡️ Subsecuente: <strong style="color:var(--ink)">${esc(m.asignatura_subsecuente)}</strong></span>` : ''}
        </div>` : ''}

        <div class="biblio-section">
            <h3 class="biblio-section__title">
                <span>📖 Bibliografía básica (${basicas.length})</span>
                <button class="btn btn--secondary btn--small" id="btnAddBibliografia">+ Agregar</button>
            </h3>
            <div class="biblio-list">
                ${basicas.length
                    ? basicas.map(biblioCardHtml).join('')
                    : '<p style="color:var(--muted);font-style:italic;padding:12px 0">Aún no hay bibliografías básicas.</p>'}
            </div>
        </div>

        <div class="biblio-section">
            <h3 class="biblio-section__title">
                <span>📚 Bibliografía complementaria (${compl.length})</span>
            </h3>
            <div class="biblio-list">
                ${compl.length
                    ? compl.map(biblioCardHtml).join('')
                    : '<p style="color:var(--muted);font-style:italic;padding:12px 0">Aún no hay bibliografías complementarias.</p>'}
            </div>
        </div>
    </div>`;
}

function biblioCardHtml(b) {
    const autoresStr = (b.autores || []).map(a => `${a.apellidos}, ${a.inicial}`).join(' · ');
    const tipoClass  = b.tipo === 'complementaria' ? 'biblio-card__type--comp' : '';
    return `
    <div class="biblio-card" data-id="${b.id}">
        <div class="biblio-card__main">
            <div class="biblio-card__autores">${esc(autoresStr || '(sin autor)')}</div>
            <div class="biblio-card__titulo">${esc(b.titulo)}</div>
            <div class="biblio-card__meta">
                <span class="biblio-card__type ${tipoClass}">${b.tipo}</span>
                ${b.anio      ? `<span>📅 ${b.anio}</span>` : ''}
                ${b.editorial ? `<span>🏢 ${esc(b.editorial)}</span>` : ''}
                ${b.pais      ? `<span>📍 ${esc(b.pais)}</span>` : ''}
                ${b.temas_recomendados ? `<span>🎯 temas ${esc(b.temas_recomendados)}</span>` : ''}
            </div>
        </div>
        <div class="biblio-card__actions">
            <button class="btn btn--secondary btn--small" data-action="cite" data-id="${b.id}">✨ Citar</button>
            <button class="btn--icon" title="Editar" data-action="edit" data-id="${b.id}">✏️</button>
            <button class="btn--icon btn--icon-danger" title="Borrar" data-action="del" data-id="${b.id}">🗑️</button>
        </div>
    </div>`;
}

function attachBiblioActions(root, onChange) {
    $$('[data-action]', root).forEach(btn => {
        btn.addEventListener('click', e => {
            e.stopPropagation();
            const { action, id } = btn.dataset;
            if (action === 'cite') abrirCita(id);
            if (action === 'edit') abrirEditarBibliografia(id);
            if (action === 'del')  confirmarBorrarBibliografia(id, onChange);
        });
    });
}

// ═══════════════════════════════════════════════════════════════
//  BIBLIOGRAFÍAS — listado general
// ═══════════════════════════════════════════════════════════════
async function loadBibliografias() {
    const cont = $('#biblioList');
    cont.innerHTML = '<div class="loading">Cargando bibliografías…</div>';
    try {
        const params = new URLSearchParams();
        if (state.searchTerm) params.set('q', state.searchTerm);
        if (state.tipoBiblio) params.set('tipo', state.tipoBiblio);
        const bibs = await api.get(`${API}/bibliografias.php?${params}`);
        if (!bibs.length) {
            cont.innerHTML = `<div class="empty">
                <div class="empty__icon">🔍</div>
                <p>${state.searchTerm
                    ? `No se encontró nada para "<strong>${esc(state.searchTerm)}</strong>".`
                    : 'No hay bibliografías aún.'}</p>
            </div>`;
            return;
        }
        cont.innerHTML = bibs.map(b => `
            <div class="biblio-card" data-id="${b.id}">
                <div class="biblio-card__main">
                    <div class="biblio-card__autores">${esc((b.autores||[]).map(a=>`${a.apellidos}, ${a.inicial}`).join(' · ') || '(sin autor)')}</div>
                    <div class="biblio-card__titulo">${esc(b.titulo)}</div>
                    <div class="biblio-card__meta">
                        <span class="biblio-card__type ${b.tipo==='complementaria'?'biblio-card__type--comp':''}">${b.tipo}</span>
                        ${b.anio      ? `<span>📅 ${b.anio}</span>` : ''}
                        ${b.editorial ? `<span>🏢 ${esc(b.editorial)}</span>` : ''}
                        <span style="color:var(--purple)">📖 ${esc(b.materia_nombre || '')}</span>
                    </div>
                </div>
                <div class="biblio-card__actions">
                    <button class="btn btn--secondary btn--small" data-action="cite" data-id="${b.id}">✨ Citar</button>
                    <button class="btn--icon" data-action="edit" data-id="${b.id}">✏️</button>
                    <button class="btn--icon btn--icon-danger" data-action="del" data-id="${b.id}">🗑️</button>
                </div>
            </div>`).join('');
        attachBiblioActions(cont, loadBibliografias);
    } catch (e) {
        cont.innerHTML = `<div class="empty"><p>${esc(e.message)}</p></div>`;
    }
}

// ═══════════════════════════════════════════════════════════════
//  AUTORES
// ═══════════════════════════════════════════════════════════════
async function loadAutores() {
    const grid = $('#autoresGrid');
    grid.innerHTML = '<div class="loading">Cargando autores…</div>';
    try {
        const q = state.searchTerm || '';
        const url = q ? `${API}/autores.php?q=${encodeURIComponent(q)}` : `${API}/autores.php`;
        const autores = await api.get(url);
        if (!autores.length) {
            grid.innerHTML = '<div class="empty"><p>No hay autores aún.</p></div>';
            return;
        }
        grid.innerHTML = autores.map(a => `
            <div class="autor-card" data-id="${a.id}">
                <div class="autor-avatar">${esc(a.apellidos.charAt(0).toUpperCase())}</div>
                <div>
                    <div class="autor-card__nombre">${esc(a.apellidos)}, ${esc(a.inicial)}</div>
                    <div class="autor-card__obras">${a.num_obras} ${+a.num_obras===1?'obra':'obras'}</div>
                </div>
            </div>`).join('');
        $$('.autor-card', grid).forEach(c =>
            c.addEventListener('click', () => abrirDetalleAutor(+c.dataset.id)));
    } catch (e) {
        grid.innerHTML = `<div class="empty"><p>${esc(e.message)}</p></div>`;
    }
}

async function abrirDetalleAutor(id) {
    state.autorActivo = id;
    $$('.view').forEach(v => v.classList.remove('view--active'));
    $('#view-detalle-autor').classList.add('view--active');
    state.view = 'detalle-autor';

    const cont = $('#detalleAutor');
    cont.innerHTML = '<div class="loading">Cargando…</div>';
    try {
        const a = await api.get(`${API}/autores.php?id=${id}`);
        cont.innerHTML = `
        <div class="materia-detalle">
            <div style="display:flex;align-items:center;gap:18px;margin-bottom:24px;flex-wrap:wrap">
                <div class="autor-avatar" style="width:64px;height:64px;font-size:22px;flex-shrink:0">
                    ${esc(a.apellidos.charAt(0).toUpperCase())}
                </div>
                <div>
                    <h2 class="materia-detalle__title">${esc(a.apellidos)}, ${esc(a.inicial)}</h2>
                    <p style="color:var(--muted);margin:4px 0 0">${(a.obras||[]).length} obras en el catálogo</p>
                </div>
            </div>
            <h3 class="biblio-section__title">📚 Obras</h3>
            <div class="biblio-list">
                ${(a.obras||[]).map(o => `
                <div class="biblio-card" data-id="${o.id}">
                    <div class="biblio-card__main">
                        <div class="biblio-card__titulo">${esc(o.titulo)}</div>
                        <div class="biblio-card__meta">
                            ${o.anio      ? `<span>📅 ${o.anio}</span>` : ''}
                            ${o.editorial ? `<span>🏢 ${esc(o.editorial)}</span>` : ''}
                            <span style="color:var(--purple)">📖 ${esc(o.materia_nombre||'')}</span>
                        </div>
                    </div>
                    <div class="biblio-card__actions">
                        <button class="btn btn--secondary btn--small" data-action="cite" data-id="${o.id}">✨ Citar</button>
                    </div>
                </div>`).join('') || '<p style="color:var(--muted);font-style:italic">Sin obras registradas.</p>'}
            </div>
        </div>`;
        attachBiblioActions(cont, () => abrirDetalleAutor(id));
    } catch (e) {
        cont.innerHTML = `<div class="empty"><p>${esc(e.message)}</p></div>`;
    }
}

// ═══════════════════════════════════════════════════════════════
//  CITAS
// ═══════════════════════════════════════════════════════════════
async function abrirCita(id) {
    openModal('modalCita');
    $('#citaTitulo').textContent = 'Cargando…';
    $('#citaOutput').textContent = '';
    try {
        const data = await api.get(`${API}/citas.php?id=${id}`);
        state.citaActual = data;
        $('#citaTitulo').textContent = data.titulo || '';
        $$('.format-tab').forEach(t =>
            t.classList.toggle('format-tab--active', t.dataset.format === 'apa'));
        renderCita('apa');
    } catch (e) {
        $('#citaOutput').textContent = 'Error: ' + e.message;
    }
}

function renderCita(formato) {
    if (!state.citaActual) return;
    $('#citaOutput').textContent = state.citaActual.citas?.[formato] || '(sin datos para este formato)';
}

async function copiarCita() {
    const texto = $('#citaOutput').textContent;
    try {
        await navigator.clipboard.writeText(texto);
        toast('¡Cita copiada al portapapeles! ✨');
    } catch {
        const ta = Object.assign(document.createElement('textarea'), { value: texto });
        document.body.appendChild(ta);
        ta.select();
        document.execCommand('copy');
        ta.remove();
        toast('¡Cita copiada! ✨');
    }
}

// ═══════════════════════════════════════════════════════════════
//  FORM MATERIA
// ═══════════════════════════════════════════════════════════════
function abrirNuevaMateria() {
    $('#modalMateriaTitle').textContent = 'Nueva materia';
    $('#formMateria').reset();
    $('#materiaId').value = '';
    // Llenar select de semestres
    const sel = $('#materiaSemestreSelect');
    sel.innerHTML = '<option value="">Seleccionar…</option>' +
        state.semestres.map(s =>
            `<option value="${s.id}">${esc(s.nombre)}</option>`).join('');
    openModal('modalMateria');
}

function abrirEditarMateria(m) {
    $('#modalMateriaTitle').textContent = 'Editar materia';
    const sel = $('#materiaSemestreSelect');
    sel.innerHTML = '<option value="">Seleccionar…</option>' +
        state.semestres.map(s =>
            `<option value="${s.id}">${esc(s.nombre)}</option>`).join('');

    const f = $('#formMateria');
    f.reset();
    // Asignar campos que existen en el form
    const campos = ['nombre','creditos','semestre_id','area','modalidad',
                    'tipo','caracter','objetivo','asignatura_antecedente',
                    'asignatura_subsecuente'];
    campos.forEach(k => { if (f[k]) f[k].value = m[k] ?? ''; });
    $('#materiaId').value = m.id;
    openModal('modalMateria');
}

async function submitMateria(e) {
    e.preventDefault();
    const id   = $('#materiaId').value;
    const data = Object.fromEntries(new FormData(e.target).entries());
    // Limpiar el campo id del body
    delete data.id;
    try {
        if (id) {
            await api.put(`${API}/materias.php?id=${id}`, data);
            toast('Materia actualizada 💜');
        } else {
            await api.post(`${API}/materias.php`, data);
            toast('Materia creada 🎉');
        }
        closeAll();
        if (id && state.view === 'detalle-materia') abrirDetalleMateria(+id);
        else switchView('materias');
    } catch (err) {
        toast('Error: ' + err.message, 'error');
    }
}

function confirmarBorrarMateria(m) {
    $('#confirmMsg').innerHTML =
        `Borrar <strong>${esc(m.nombre)}</strong> también eliminará sus
         <strong>${(m.bibliografias||[]).length} bibliografía(s)</strong>. ¿Continuar?`;
    openModal('modalConfirm');
    const btn = $('#btnConfirmYes');
    const handler = async () => {
        btn.removeEventListener('click', handler);
        try {
            await api.del(`${API}/materias.php?id=${m.id}`);
            toast('Materia borrada', 'success');
            closeAll();
            switchView('materias');
        } catch (err) {
            toast('Error: ' + err.message, 'error');
        }
    };
    btn.addEventListener('click', handler);
}

// ═══════════════════════════════════════════════════════════════
//  FORM BIBLIOGRAFÍA
// ═══════════════════════════════════════════════════════════════
async function llenarMateriasSelect(selectedId = null) {
    try {
        const mats = await api.get(`${API}/materias.php`);
        const sel  = $('#bibMateriaSelect');
        sel.innerHTML = '<option value="">— Selecciona materia —</option>' +
            mats.map(m =>
                `<option value="${m.id}">${esc(m.nombre)} (${esc(m.semestre_nombre||'')})</option>`
            ).join('');
        if (selectedId) sel.value = String(selectedId);
    } catch (e) {
        toast('Error cargando materias: ' + e.message, 'error');
    }
}

async function abrirNuevaBibliografia(materiaId = null) {
    $('#modalBibTitle').textContent = 'Nueva bibliografía';
    $('#formBibliografia').reset();
    $('#bibId').value = '';
    $('.article-fields').classList.remove('show');
    await llenarMateriasSelect(materiaId);
    renderAutoresInputs([]);
    openModal('modalBibliografia');
}

async function abrirEditarBibliografia(id) {
    try {
        const b = await api.get(`${API}/bibliografias.php?id=${id}`);
        $('#modalBibTitle').textContent = 'Editar bibliografía';
        const f = $('#formBibliografia');
        f.reset();
        await llenarMateriasSelect(b.materia_id);

        const campos = ['tipo','tipo_recurso','titulo','subtitulo','anio','editorial',
                        'ciudad','pais','edicion','revista','volumen','numero_revista',
                        'paginas','doi','isbn','issn','url','temas_recomendados'];
        campos.forEach(k => { if (f[k]) f[k].value = b[k] ?? ''; });
        $('#bibId').value = b.id;
        $('.article-fields').classList.toggle('show', b.tipo_recurso === 'articulo');
        renderAutoresInputs(b.autores || []);
        openModal('modalBibliografia');
    } catch (e) {
        toast('Error: ' + e.message, 'error');
    }
}

function renderAutoresInputs(autores) {
    const list = $('#autoresList');
    list.innerHTML = '';
    if (!autores.length) agregarAutorInput();
    else autores.forEach(a => agregarAutorInput(a));
}

function agregarAutorInput(a = null) {
    const div = document.createElement('div');
    div.className = 'autor-row';
    div.innerHTML = `
        <input type="text" placeholder="Apellido(s)"  value="${esc(a?.apellidos||'')}" class="autor-apellidos">
        <input type="text" placeholder="Inicial (P.)" value="${esc(a?.inicial  ||'')}" class="autor-inicial">
        <button type="button" class="autor-row__remove" title="Quitar">×</button>`;
    div.querySelector('.autor-row__remove').addEventListener('click', () => {
        if ($('#autoresList').children.length > 1) div.remove();
        else toast('Debe haber al menos un autor', 'info');
    });
    $('#autoresList').appendChild(div);
}

async function submitBibliografia(e) {
    e.preventDefault();
    const id   = $('#bibId').value;
    const data = Object.fromEntries(new FormData(e.target).entries());
    delete data.id;

    // Limpiar campos numéricos vacíos
    if (!data.anio) delete data.anio;

    // Recolectar autores
    data.autores = $$('.autor-row').map(row => ({
        apellidos: row.querySelector('.autor-apellidos').value.trim(),
        inicial:   row.querySelector('.autor-inicial').value.trim(),
    })).filter(a => a.apellidos && a.inicial);

    if (!data.autores.length) {
        toast('Agrega al menos un autor válido', 'error');
        return;
    }

    try {
        if (id) {
            await api.put(`${API}/bibliografias.php?id=${id}`, data);
            toast('Bibliografía actualizada 💜');
        } else {
            await api.post(`${API}/bibliografias.php`, data);
            toast('Bibliografía creada 🎉');
        }
        closeAll();
        if (state.view === 'detalle-materia' && state.materiaActiva) {
            abrirDetalleMateria(state.materiaActiva);
        } else {
            loadBibliografias();
        }
    } catch (err) {
        toast('Error: ' + err.message, 'error');
    }
}

function confirmarBorrarBibliografia(id, after) {
    $('#confirmMsg').textContent = '¿Borrar esta bibliografía? Esta acción no se puede deshacer.';
    openModal('modalConfirm');
    const btn = $('#btnConfirmYes');
    const handler = async () => {
        btn.removeEventListener('click', handler);
        try {
            await api.del(`${API}/bibliografias.php?id=${id}`);
            toast('Bibliografía borrada');
            closeAll();
            if (typeof after === 'function') after();
        } catch (err) {
            toast('Error: ' + err.message, 'error');
        }
    };
    btn.addEventListener('click', handler);
}

// Exponer para onclick inline del HTML
window.abrirNuevaMateria = abrirNuevaMateria;