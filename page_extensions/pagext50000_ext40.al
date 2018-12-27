pageextension 50000 "Item Journal Page Ext." extends "Item Journal"
{
    layout
    {
        addafter(Quantity)
        {
            field("Entry Lot No."; "Entry Lot No.")
            {
                ApplicationArea = All;
            }
        }
    }
}