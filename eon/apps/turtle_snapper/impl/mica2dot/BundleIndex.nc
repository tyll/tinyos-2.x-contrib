/*
 * file:       BundleIndex.nc
 * description: BundleIndex object interface
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
 
 */
includes app_header;
includes userstructs;


interface BundleIndex 
{
	command result_t init();
	
	command result_t load(bool ecc);
	
	event void loadDone(result_t res);
	
    command result_t BeginTraversal();
	
	
	command result_t GetBundleByOffset(int16_t offset, Bundle_t* bundle, bool *isvalid);
	command result_t GetBundle(Bundle_t* bundle);
	event void GetBundleDone(result_t res, bool valid);
	
	command result_t GoNext();
	
	command result_t DeleteBundleByOffset(int16_t offset, bool *isvalid);
	command result_t DeleteBundle();
	event void DeleteBundleDone(result_t res);

	command result_t AppendBundle(Bundle_t* bundle);
	event void AppendDone(result_t res);
	
	command result_t save(flashptr_t *save_ptr);
	event void saveDone(result_t res);

    
}
