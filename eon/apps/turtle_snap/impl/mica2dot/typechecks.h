#ifndef TYPECHECKS_H_INCLUDED
#define TYPECHECKS_H_INCLUDED

/*
	AM_BEGIN_TRAVERSAL_MSG = 17,
	AM_GO_NEXT_MSG = 18,
	AM_GET_NEXT_CHUNK = 19,
	AM_GET_BUNDLE_MSG = 20,
	AM_DELETE_BUNDLE_MSG = 21,
	AM_END_DATA_COLLECTION_SESSION = 22,
	AM_BUNDLE_INDEX_ACK = 23
*/

bool
IsGetNextChunkMsg (int value)
{
	return value == AM_GET_NEXT_CHUNK;
}

bool
IsBeginTraversalMsg (int value)
{
	return value == AM_BEGIN_TRAVERSAL_MSG;
}

bool
IsGoNextMsg (int value)
{
	return value == AM_GO_NEXT_MSG;
}

bool
IsDeleteBundleMsg (int value)
{
	return value == AM_DELETE_BUNDLE_MSG;
}

bool
IsDeleteAllBundlesMsg (int value)
{
	return value == AM_DELETE_ALL_BUNDLES_MSG;
}

bool
IsStreamFull (uint32_t value)
{
	return value > 1;
}

bool
IsEndCollectionSession (int value)
{
	return value == AM_END_DATA_COLLECTION_SESSION;
}

bool
IsGetBundleMsg (int value)
{
	return value == AM_GET_BUNDLE_MSG;
}

#endif // TYPECHECKS_H_INCLUDED
