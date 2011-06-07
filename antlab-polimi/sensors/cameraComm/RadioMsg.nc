/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
interface RadioMsg
{
	/**
	 * broadcasts a message
	 * @param start1 the start of the data to be sent
	 * @param end1 points one byte after the last byte of the data.
	 * @return FAIL if the component is busy sending another message
	 */
	command error_t sendPhoto(uint8_t *start_buf, uint32_t total_size);
	command error_t sendPhotoRadio(uint8_t *start_buf, uint32_t total_size);
	
	/**
	 * broadcasts a light message(1 byte less)
	 * @param start1 the start of the data to be sent
	 * @param end1 points one byte after the last byte of the data.
	 * @return FAIL if the component is busy sending another message
	 */
	command error_t sendVideoFrame(uint8_t *start_buf, uint32_t total_size,uint8_t frame_num);
        command error_t sendVideoFrameRadio(uint8_t *start_buf, uint32_t total_size,uint8_t frame_num);

	//img stat send radio
	command error_t sendImgStatRadio(uint16_t width, uint16_t height, uint32_t size);
	command error_t sendImgStat(uint16_t width, uint16_t height, uint32_t size);

	/**
	 * Re-Sends parts of a message
	 * @param start_buf  - the start of the data to be sent
	 * @param from  - points to the first frame
	 * @param numFrames - number of consecutive frames to send
	 * @return FAIL if the component is busy sending another message
	 */
	//command error_t resend(uint8_t *start_buf, uint16_t from, uint16_t numFrames);
	


	/**
	 * Fired when a successfully initiated <code>send</code> terminates.
	 * @param success SUCCESS, if the message was sent succesfully.
	 */
	event void sendPhotoDone(error_t success);
	event void sendPhotoRadioDone(error_t success);
	event void sendVideoFrameDone(error_t success);
	event void sendVideoFrameRadioDone(error_t success);
	event void sendImgStatDone(error_t success);
	event void sendImgStatRadioDone(error_t success);
	
}
