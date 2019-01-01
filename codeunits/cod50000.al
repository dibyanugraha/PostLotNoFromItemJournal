codeunit 50100 "Manage Reserv. Entry"
{
    local procedure CreateReservEntryManually(itemJnlLine: Record "Item Journal Line")
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
    begin
        CreateReservEntry.SetDates(0D, 0D);
        CreateReservEntry.CreateReservEntryFor(
            DATABASE::"Item Journal Line", 0,
            itemJnlLine."Document No.", '', 0, itemJnlLine."Line No.", itemJnlLine."Qty. Per Unit of Measure",
            itemJnlLine.Quantity, itemJnlLine."Quantity (Base)", '', itemJnlLine."Entry Lot No.");
        CreateReservEntry.CreateEntry(itemJnlLine."Item No.", '', itemJnlLine."Location Code",
            itemJnlLine.Description, 0D, 0D, 0, 3); // must be prospect
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

    procedure InsertItemJournalLine(var ItemJournalLine: Record "Item Journal Line")
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
        if ItemJournalLine."Document Type" = ItemJournalLine."Document Type"::" " then
            JournalIsMadeFromItemJournal := true;

        // remove the manual reservation entries
        if EnableInsert and JournalIsMadeFromItemJournal then
            CreateReservEntryManually(ItemJournalLine);
    end;
}