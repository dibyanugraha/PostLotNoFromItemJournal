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
                if (xRec."Entry Lot No." <> "Entry Lot No.") and ("Entry Lot No." <> '') then begin
                    MgtReservManual.DeleteReservation(Rec);
                    MgtReservManual.InsertItemJournalLine(Rec);
                end else
                    MgtReservManual.DeleteReservation(Rec)
            end;
        }
    }
}