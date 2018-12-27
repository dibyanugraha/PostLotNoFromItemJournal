tableextension 50000 "Item Journal Line Ext." extends "Item Journal Line"
{
    fields
    {
        field(50000; "Entry Lot No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
    }
}