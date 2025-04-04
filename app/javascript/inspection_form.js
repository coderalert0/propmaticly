document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('[id^="state-select-"]').forEach(select => {
        const inspectionId = select.id.split('-').pop();
        const filingDateGroup = document.getElementById(`filing-date-group-${inspectionId}`);
        const filing_date_field = filingDateGroup.querySelector('input');

        const toggleFilingDate = () => {
            if (select.value === 'closed') {
                filingDateGroup.style.display = 'flex';
                filing_date_field.setAttribute('required', 'required');
            } else {
                filingDateGroup.style.display = 'none';
                filing_date_field.removeAttribute('required');
            }
        };

        select.addEventListener('change', toggleFilingDate);
        toggleFilingDate(); // Initial visibility
    });
});
