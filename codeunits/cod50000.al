codeunit 50000 "Insert Reservation Entry"
{
    TableNo = "Item Journal Line";

    trigger OnRun()
    begin
        CreateReservEntry.SetDates(0D, 0D);
        CreateReservEntry.CreateReservEntryFor(
            DATABASE::"Item Journal Line", 0,
            "Document No.", '', 0, "Line No.", "Qty. Per Unit of Measure",
            Quantity, "Quantity (Base)", '', "Entry Lot No.");
        CreateReservEntry.CreateEntry("Item No.", '', "Location Code",
            Description, 0D, 0D, 0, 3); // prospect
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Check Line", 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure MyProcedure()
    begin

    end;

    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";

}