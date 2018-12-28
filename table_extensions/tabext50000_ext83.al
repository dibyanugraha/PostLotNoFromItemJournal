tableextension 50100 "Item Journal Line Ext." extends "Item Journal Line"
{
    fields
    {
        field(50000; "Entry Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if xRec."Entry Lot No." <> "Entry Lot No." then begin
                    // delete (might empty) then recreate

                end else
                    if "Entry Lot No." = '' then begin
                        // just delete
                    end;
            end;
        }
    }
}