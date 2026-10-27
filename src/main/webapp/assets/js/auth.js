/* Person 1 only. Navigation and writes remain ordinary Servlet links and forms. */
(() => {
    'use strict';
    const root = document.querySelector('.tg-person1');
    if (!root) return;

    root.querySelectorAll('[data-password-toggle]').forEach(button => {
        const field = document.getElementById(button.dataset.passwordToggle);
        if (!field) return;
        button.hidden = false;
        button.addEventListener('click', () => {
            const show = field.type === 'password';
            field.type = show ? 'text' : 'password';
            button.textContent = show ? '\u1ea8n' : 'Hi\u1ec7n';
            button.setAttribute('aria-pressed', String(show));
            button.setAttribute('aria-label', (show ? '\u1ea8n' : 'Hi\u1ec7n') + ' m\u1eadt kh\u1ea9u');
        });
    });

    root.querySelectorAll('form[data-password-validation]').forEach(form => {
        const password = form.elements.namedItem('password');
        const confirmation = form.elements.namedItem('confirmPassword');
        const validate = () => {
            if (password) {
                const tooLong = new TextEncoder().encode(password.value).length > 72;
                password.setCustomValidity(tooLong ? 'M\u1eadt kh\u1ea9u t\u1ed1i \u0111a 72 byte UTF-8.' : '');
            }
            if (confirmation && password) {
                confirmation.setCustomValidity(confirmation.value && confirmation.value !== password.value
                    ? 'X\u00e1c nh\u1eadn m\u1eadt kh\u1ea9u ch\u01b0a kh\u1edbp.' : '');
            }
        };
        if (password) password.addEventListener('input', validate);
        if (confirmation) confirmation.addEventListener('input', validate);
        form.addEventListener('submit', event => {
            validate();
            if (!form.checkValidity()) { event.preventDefault(); form.reportValidity(); }
        });
    });

    const openDialog = dialog => {
        if (!dialog || typeof dialog.showModal !== 'function') return;
        if (!dialog.open) dialog.showModal();
        const alert = dialog.querySelector('[data-backend-error]');
        if (alert) alert.focus();
    };
    root.querySelectorAll('[data-dialog-target]').forEach(button => {
        button.addEventListener('click', () => openDialog(document.getElementById(button.dataset.dialogTarget)));
    });
    root.querySelectorAll('[data-dialog-close]').forEach(button => {
        button.addEventListener('click', () => button.closest('dialog').close());
    });
    root.querySelectorAll('dialog[data-auto-open="true"]').forEach(openDialog);

    const table = root.querySelector('[data-user-table]');
    if (table) {
        const rows = Array.from(table.querySelectorAll('tbody tr[data-user-row]'));
        const role = root.querySelector('[data-role-filter]');
        const status = root.querySelector('[data-status-filter]');
        const empty = root.querySelector('[data-filter-empty]');
        const count = root.querySelector('[data-result-count]');
        const pager = root.querySelector('[data-user-pagination]');
        const pageSize = 10;
        let page = 1;
        const render = () => {
            const filtered = rows.filter(row => (!role.value || row.dataset.role === role.value)
                && (!status.value || row.dataset.active === status.value));
            const pageCount = Math.max(1, Math.ceil(filtered.length / pageSize));
            page = Math.min(page, pageCount);
            rows.forEach(row => { row.hidden = true; });
            filtered.slice((page - 1) * pageSize, page * pageSize).forEach(row => { row.hidden = false; });
            empty.hidden = filtered.length !== 0;
            count.textContent = filtered.length ? ((page - 1) * pageSize + 1) + '\u2013'
                + Math.min(page * pageSize, filtered.length) + ' / ' + filtered.length + ' ng\u01b0\u1eddi d\u00f9ng' : '0 ng\u01b0\u1eddi d\u00f9ng';
            pager.replaceChildren();
            if (pageCount <= 1) return;
            const add = (label, destination, current, disabled) => {
                const button = document.createElement('button');
                button.type = 'button'; button.textContent = label; button.disabled = disabled;
                button.setAttribute('aria-label', label === '\u2190' ? 'Trang tr\u01b0\u1edbc' : label === '\u2192' ? 'Trang sau' : 'Trang ' + label);
                if (current) button.setAttribute('aria-current', 'page');
                button.addEventListener('click', () => { page = destination; render(); });
                pager.append(button);
            };
            add('\u2190', page - 1, false, page === 1);
            for (let index = 1; index <= pageCount; index++) {
                if (index === 1 || index === pageCount || Math.abs(index - page) <= 1) add(String(index), index, index === page, false);
                else if (index === page - 2 || index === page + 2) { const dots = document.createElement('span'); dots.textContent = '\u2026'; pager.append(dots); }
            }
            add('\u2192', page + 1, false, page === pageCount);
        };
        role.addEventListener('change', () => { page = 1; render(); });
        status.addEventListener('change', () => { page = 1; render(); });
        render();
    }
})();
