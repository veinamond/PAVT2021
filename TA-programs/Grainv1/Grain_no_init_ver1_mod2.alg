﻿
// keystream length 
define stream_len 160;

__in bit NFSR[80];
__in bit LFSR[80];

__out bit stream[stream_len];

void LFSR_shift()
{
	bit y = LFSR[0]^LFSR[13]^LFSR[23]^LFSR[38]^LFSR[51]^LFSR[62];
	
	for(int j = 0; j < 79; j = j + 1)
	{
		LFSR[j] = LFSR[j + 1];
	}
	LFSR[79] = y;
}

void NFSR_shift()
{
	__mem bit t10 = NFSR[37] & NFSR[33];
	__mem bit t11 = NFSR[28] & NFSR[21];
	__mem bit t0 = NFSR[52] & NFSR[45];
	__mem bit t12 = t0 & t10 & t11;
	__mem bit t13 = NFSR[33] & t11;
	
	__mem bit t14 = NFSR[52] ^ NFSR[45] ^ NFSR[37];
	__mem bit t15 = NFSR[33] ^ NFSR[28] ^ NFSR[21];
	__mem bit t16 = t12 ^ t13 ^ t10;
	
	__mem bit y1 = t16 ^ t14 ^ t15;
	//__mem bit y1 = NFSR[52]&NFSR[45]&NFSR[37]&NFSR[33]&NFSR[28]&NFSR[21] ^ 
	//	NFSR[33]&NFSR[28]&NFSR[21] ^ NFSR[37]&NFSR[33] ^ NFSR[52] ^ NFSR[45] ^ NFSR[37] ^ 
	//	NFSR[33] ^ NFSR[28] ^ NFSR[21];

	__mem bit t20 = NFSR[15] & NFSR[9];
	__mem bit t21 = t20 & NFSR[33] & NFSR[28] & NFSR[21];
	__mem bit t22 = NFSR[14] ^ NFSR[9];
	
	__mem bit y2 = t21 ^ t20 ^ t22;
	//__mem bit y2 = NFSR[33]&NFSR[28]&NFSR[21]&NFSR[15]&NFSR[9] ^ NFSR[15]&NFSR[9] ^ NFSR[14] ^ NFSR[9];
	
	
	__mem bit t30 = NFSR[63] & NFSR[60];
	__mem bit t31 = NFSR[60] & t0;
	__mem bit t32 = t30 & t0 & NFSR[37];
	__mem bit t33 = NFSR[60] & NFSR[52] & t10;
	
	__mem bit y3 = t32 ^ t31 ^ t33;
	//__mem bit y3 = NFSR[63]&NFSR[60]&NFSR[52]&NFSR[45]&NFSR[37] ^ NFSR[60]&NFSR[52]&NFSR[45] ^ NFSR[60]&NFSR[52]&NFSR[37]&NFSR[33];
	
	__mem bit t40 = t30 & NFSR[21] & NFSR[15];
	__mem bit t41 =  NFSR[62] ^ NFSR[60];
	
	__mem bit y4 = t40 ^ t30 ^ t41;
	
	//__mem bit y4 = NFSR[63]&NFSR[60]&NFSR[21]&NFSR[15] ^ NFSR[63]&NFSR[60] ^ NFSR[62] ^ NFSR[60];
	
	__mem bit t50 = NFSR[63]&NFSR[45]&NFSR[28]&NFSR[9];
	
	__mem bit y5 =  NFSR[0] ^ t50;
	
	//__mem bit y5 =  NFSR[0] ^ NFSR[63]&NFSR[45]&NFSR[28]&NFSR[9];
	
	__mem bit t60 = y1 ^ y2 ^ y3;
	//__mem bit y = y1 ^ y2 ^ y3 ^ y4 ^ y5;
	__mem bit y = t60 ^ y4 ^ y5;

	for(int j = 0; j < 79; j = j + 1)
	{
		NFSR[j] = NFSR[j + 1];
	}

	NFSR[79] = y ^ LFSR[0];
}

bit H(bit x0, bit x1, bit x2, bit x3, bit x4)
{
	__mem bit tx0 = x0 & x3;
	__mem bit tx1 = x2 & x3;
	__mem bit tx2 = x3 & x4;
	__mem bit tx3 = x0 & x1 & x2;
	__mem bit tx4 = x0 & tx1;
	__mem bit tx5 = x0 & x2 & x4;
	__mem bit tx6 = x1 & x2 & x4;
	__mem bit tx7 = tx1 & x4;
	
	__mem bit tx8 = x1 ^ x4 ^ tx0;
	__mem bit tx9 = tx1 ^ tx2 ^ tx3;
	__mem bit tx10 = tx4 ^ tx5 ^ tx6;
	__mem bit tx11 = tx8 ^ tx9 ^ tx10;
	
	return tx11 ^ tx7;
	
	//return x1 ^ x4 ^ x0&x3 ^ x2&x3 ^ x3&x4 ^ x0&x1&x2 ^ x0&x2&x3 ^ x0&x2&x4 ^ x1&x2&x4 ^ x2&x3&x4;
}

void main()
{
	for(int i = 0; i < stream_len; i = i + 1)
	{
		__mem bit t1 = NFSR[1] ^ NFSR[2] ^ NFSR[4];
		__mem bit t2 = NFSR[10] ^ NFSR[31] ^ NFSR[43];
		__mem bit t3 = t1 ^ t2 ^ NFSR[56];
		bit out = t3 ^ H(LFSR[3], LFSR[25], LFSR[46], LFSR[64], NFSR[63]);

		NFSR_shift();
		LFSR_shift();		
		
		stream[i] = out;
	}
}
