.definelabel beh_item_box_icon, (org()-0x80000000)
.word 0x00080000
.word 0x11010001
.word 0x2D000000
.word 0x08000000
.word 0x0C000000, @item_box_icon_loop
.word 0x09000000

@item_box_icon_loop:
LW T0, g_current_obj_ptr
LW AT, o_state (T0)
BEQ AT, R0, @box_active
NOP
B @box_broken
NOP

@box_active:
LW T1, o_timer (T0)
ORI AT, R0, 0x3
DIVU T1, AT
ORI AT, R0, 0x2
MFHI T1
SW AT, o_animation_frame (T0)
BEQ T1, R0, @return
LBU AT, o_arg0 (T0)
SW AT, o_animation_frame (T0)
@return:
JR RA
NOP

@box_broken:
LBU AT, o_arg0 (T0)
SW AT, o_animation_frame (T0)
LW T1, o_timer (T0)
ORI AT, R0, 0x28
BNE T1, AT, @endif_despawn
NOP
	J mark_object_for_deletion
	SLL A0, T0, 0x0
@endif_despawn:
ORI T2, R0, 0x1A
BLT T1, T2, @endif_at_max_height
NOP
	SLL T1, T2, 0x0
@endif_at_max_height:
MTC1 T1, F5
LI AT, 0x413C7627
MTC1 AT, F6
L.S F4, o_home_y (T0)
CVT.S.W F5, F5
MUL.S F5, F5, F6
ADD.S F4, F4, F5
JR RA
S.S F4, o_y (T0)
