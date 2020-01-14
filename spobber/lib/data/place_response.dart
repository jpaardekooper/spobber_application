/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

class PlaceResponse {
 final String secretId;
 final String equipmentId;
 final String type;
 final String placement;
 final double latitude;
 final double longitude;
 final String source;
 final String previewImageUri;
 final String objectUri;
 final String readableID;

  PlaceResponse(
      {this.secretId,
      this.equipmentId,
      this.type,
      this.placement,
      this.latitude,
      this.longitude,
      this.source,
      this.previewImageUri,
      this.objectUri,
      this.readableID});
  //PlaceResponse({this.id, this.type, this.latitude, this.longitude, this.status, this.preview_image_uri, this.object_uri});

  PlaceResponse fromJson(Map<String, dynamic> json) {
    return PlaceResponse(
        // htmlAttributions: List<String>.from(json['html_attributions']),
        // nextPageToken: json['next_page_token'],
        // results: parseResults(json['results']),
        // status: json['status']);
        secretId: json['secret_id'],
        equipmentId: json['equipment_id'],
        type: json['type'],
        placement: json['placement'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        source: json['source'],
        previewImageUri: json['preview_image_uri'],
        objectUri: json['object_uri'],
        readableID: json['readable_id']);
  }
}
