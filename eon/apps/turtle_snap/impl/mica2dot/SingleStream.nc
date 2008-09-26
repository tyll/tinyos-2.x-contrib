/*
 * file:        SingleStream.nc
 * description: SingleStream interface
 *
 * author:      Jacob Sorber, UMass Computer Science Dept.
 * $Id$
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/*
 * The stream storage object
 */
 includes sizes;
includes app_header;

includes SingleStream;

interface SingleStream
{
    command result_t init(stream_t *stream_ptr, bool ecc);

    /* Write more data to the stream */
    command result_t append(stream_t *stream_ptr, void *data, datalen_t len, flashptr_t *save_ptr);

    event void appendDone(stream_t *stream_ptr, result_t res);

    /* Start traversal at most recently written chunk */
    command result_t start_traversal(stream_t *stream_ptr, flashptr_t *start_ptr);

    /* Get previous stream chunk */
    command result_t next(stream_t *stream_ptr, void *data, datalen_t *len);

    event void nextDone(stream_t *stream_ptr, result_t res);
}
