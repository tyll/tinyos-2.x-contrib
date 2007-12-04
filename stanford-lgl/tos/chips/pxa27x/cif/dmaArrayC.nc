configuration dmaArrayC{
    provides interface dmaArray;
}

implementation
{
	components dmaArrayM;
	dmaArray = dmaArrayM;
}
