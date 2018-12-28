pageextension 50101 "Inventory Setup Ext." extends "Inventory Setup"
{
    layout
    {
        addafter(General)
        {
            field("Enable Insert Lot No."; "Enable Insert Lot No.")
            {
                ApplicationArea = All;
            }
        }
    }
}