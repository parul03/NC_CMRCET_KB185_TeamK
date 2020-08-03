function AddDataTable(table, searching) {
    $(table).DataTable({
        "searching": searching
    });
    $.fn.dataTable.ext.errMode = 'none';
    $(table).on('error.dt', function (e, settings, techNote, message) {
        console.log('An error has been reported by DataTables: ', message);
    });
}