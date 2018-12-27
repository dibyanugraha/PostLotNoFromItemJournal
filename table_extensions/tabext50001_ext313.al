tableextension 50001 "Inventory Setup Ext." extends "Inventory Setup"
{
    fields
    {
        field(50000; "Enable Insert Lot No."; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (xRec."Enable Insert Lot No." = false) and "Enable Insert Lot No." then begin
                    if Confirm(txtConfEnableInsert, true) then
                        "Enable Insert Lot No." := true;
                end;
            end;
        }
    }
    var
        txtConfEnableInsert: Label 'Enabling this will force user to input Lot No. in every positive adjustment/purchases made through Item Journal. Continue?';
}