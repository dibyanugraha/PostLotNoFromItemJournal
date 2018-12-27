codeunit 50000 "Manage Reserv. Entry"
{
    TableNo = "Item Journal Line";

    trigger OnRun()
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
    begin
        CreateReservEntry.SetDates(0D, 0D);
        CreateReservEntry.CreateReservEntryFor(
            DATABASE::"Item Journal Line", 0,
            "Document No.", '', 0, "Line No.", "Qty. Per Unit of Measure",
            Quantity, "Quantity (Base)", '', "Entry Lot No.");
        CreateReservEntry.CreateEntry("Item No.", '', "Location Code",
            Description, 0D, 0D, 0, 3); // must be prospect
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Check Line", 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure CheckLotNoIsInserted(var ItemJnlLine: Record "Item Journal Line")
    var
        InvSet: Record "Inventory Setup";
        EnableInsert: Boolean;
        JournalIsMadeFromItemJournal: Boolean;
    begin
        Clear(EnableInsert);
        Clear(JournalIsMadeFromItemJournal);

        InvSet.Get();
        if InvSet."Enable Insert Lot No." then
            EnableInsert := true;
        if ItemJnlLine."Document Type" = ItemJnlLine."Document Type"::" " then
            JournalIsMadeFromItemJournal := true;

        if EnableInsert and JournalIsMadeFromItemJournal then
            ItemJnlLine.TestField("Entry Lot No.");
    end;

}