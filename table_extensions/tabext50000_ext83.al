tableextension 50100 "Item Journal Line Ext." extends "Item Journal Line"
{
    fields
    {
        field(50000; "Entry Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                MgtReservManual: Codeunit "Manage Reserv. Entry";
            begin
                if xRec."Entry Lot No." <> "Entry Lot No." then begin
                    DeleteReservation();
                    MgtReservManual.InsertItemJournalLine(Rec);
                end else
                    if "Entry Lot No." = '' then begin
                        DeleteReservation();
                    end;
            end;
        }
    }

    local procedure DeleteReservation()
    var
        ReservMgt: Codeunit "Reservation Management";
    begin
        ReservMgt.SetItemJnlLine(Rec);
        ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE, 0);
    end;
}