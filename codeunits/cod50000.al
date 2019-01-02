codeunit 50100 "Manage Reserv. Entry"
{
    local procedure CreateReservEntryManually(var itemJnlLine: Record "Item Journal Line")
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ProcessSpecification: Record "Tracking Specification";
    begin
        CreateReservEntry.SetDates(0D, 0D);
        CreateReservEntry.CreateReservEntryFor(
            DATABASE::"Item Journal Line", 0,
            itemJnlLine."Journal Template Name",
            itemJnlLine."Journal Batch Name", 0,
            itemJnlLine."Line No.", itemJnlLine."Qty. Per Unit of Measure",
            itemJnlLine.Quantity, itemJnlLine."Quantity (Base)", '', itemJnlLine."Entry Lot No.");
        CreateReservEntry.CreateEntry(itemJnlLine."Item No.", '', itemJnlLine."Location Code",
            itemJnlLine.Description, 0D, 0D, 0, 3); // must be prospect
        ProcessSpecification.CheckItemTrackingQuantity(DATABASE::"Item Journal Line",
            ItemJnlLine."Entry Type"::"Positive Adjmt.",
            itemJnlLine."Document No.", itemJnlLine."Line No.",
            itemJnlLine.Quantity * itemJnlLine."Qty. Per Unit of Measure",
            itemJnlLine.Quantity * itemJnlLine."Qty. Per Unit of Measure",
            TRUE, TRUE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Check Line", 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure CheckLotNoIsInserted(var ItemJnlLine: Record "Item Journal Line")
    begin
        if CheckSetting(ItemJnlLine) then
            ItemJnlLine.TestField("Entry Lot No.");
    end;

    local procedure CheckSetting(var ItemJnlLine: Record "Item Journal Line"): Boolean
    var
        JournalIsMadeFromItemJournal: Boolean;
    begin
        Clear(JournalIsMadeFromItemJournal);

        if ItemJnlLine."Document Type" = ItemJnlLine."Document Type"::" " then
            JournalIsMadeFromItemJournal := true;
        if JournalIsMadeFromItemJournal then
            exit(true);
        exit(false);
    end;

    procedure InsertItemJournalLine(var ItemJournalLine: Record "Item Journal Line")
    begin
        if CheckSetting(ItemJournalLine) then
            CreateReservEntryManually(ItemJournalLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure RemoveManualReservation(RunTrigger: Boolean; var Rec: Record "Item Journal Line")
    var
        MgtReservManual: Codeunit "Manage Reserv. Entry";
    begin
        if CheckSetting(Rec) then
            DeleteReservation(Rec);
    end;

    procedure DeleteReservation(var itemJnlLine: Record "Item Journal Line")
    var
        ReservMgt: Codeunit "Reservation Management";
    begin
        ReservMgt.SetItemJnlLine(itemJnlLine);
        ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE, 0);
    end;
}