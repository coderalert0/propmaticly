document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('[id^="state-select-"]').forEach(select => {
        const inspectionId = select.id.split('-').pop();
        const filingDateGroup = document.getElementById(`filing-date-group-${inspectionId}`);

        const toggleFilingDate = () => {
            filingDateGroup.style.display = select.value === 'closed' ? 'flex' : 'none';
        };

        select.addEventListener('change', toggleFilingDate);
        toggleFilingDate(); // Initial visibility
    });
});
