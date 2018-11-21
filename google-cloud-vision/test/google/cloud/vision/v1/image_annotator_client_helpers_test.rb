# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "minitest/autorun"
require "minitest/spec"

require "google/gax"

require "google/cloud/vision"
require "google/cloud/vision/v1/image_annotator_client"
require "google/cloud/vision/v1/image_annotator_client_helpers"

class MockGrpcClientStub_v1
  # @param expected_symbol [Symbol] the symbol of the grpc method to be mocked.
  # @param mock_method [Proc] The method that is being mocked.
  def initialize expected_symbol, mock_method
    @expected_symbol = expected_symbol
    @mock_method = mock_method
  end

  # This overrides the Object#method method to return the mocked method when the mocked method
  # is being requested. For methods that aren"t being tested, this method returns a proc that
  # will raise an error when called. This is to assure that only the mocked grpc method is being
  # called.
  #
  # @param symbol [Symbol] The symbol of the method being requested.
  # @return [Proc] The proc of the requested method. If the requested method is not being mocked
  #   the proc returned will raise when called.
  def method symbol
    return @mock_method if symbol == @expected_symbol

    # The requested method is not being tested, raise if it called.
    proc do
      raise "The method #{symbol} was unexpectedly called during the " \
        "test for #{@expected_symbol}."
    end
  end
end

class MockImageAnnotatorCredentials_v1 < Google::Cloud::Vision::V1::Credentials
  def initialize method_name
    @method_name = method_name
  end

  def updater_proc
    proc do
      raise "The method `#{@method_name}` was trying to make a grpc request. This should not " \
          "happen since the grpc layer is being mocked."
    end
  end
end

describe Google::Cloud::Vision::V1::ImageAnnotatorClient do
  let(:image_file) { File.new("acceptance/data/face.jpg", "r") }
  let(:image_files) do 
    (0..1).map { image_file }
  end
  let(:image_path) { "acceptance/data/face.jpg" }
  let(:image_paths) do 
    (0..1).map { image_path }
  end
  let(:image_uri) { "http://example.com/face.jpg" }
  let(:image_uris) do 
    (0..1).map { image_uri }
  end
  let(:gcs_image_uri) { "gs://gapic-toolkit/President_Barack_Obama.jpg" }
  let(:gcs_image_uris) do 
    (0..1).map { gcs_image_uri }
  end
  let(:mock_credentials) { MockImageAnnotatorCredentials_v1.new("batch_annotate_images") }

  def image_object image
    return { content: File.binread(image_file) } if File.file? image
    return { source: { image_uri: image_uri } } if image == image_uri
    { source: { gcs_image_uri: gcs_image_uri } }
  end

  def batch_annotate_stub image, feature_type
    expected_requests =
      if image.is_a? Array
        (0...image.size).map do |n|
          {
            image: image_object(image[n]),
            features: [{ type: feature_type }]
          }
        end
      else
        [{
          image: image_object(image),
          features: [{ type: feature_type }]
        }]
      end
    proc do |requests|
      assert_equal(expected_requests, requests)
    end
  end

  def make_helper_call client, opts, feature
    client.face_detection opts if feature == :FACE_DETECTION
    client.landmark_detection opts if feature == :LANDMARK_DETECTION
    client.logo_detection opts if feature == :LOGO_DETECTION
    client.label_detection opts if feature == :LABEL_DETECTION
    client.text_detection opts if feature == :TEXT_DETECTION
    client.document_text_detection opts if feature == :DOCUMENT_TEXT_DETECTION
    client.safe_search_detection opts if feature == :SAFE_SEARCH_DETECTION
    client.image_properties opts if feature == :IMAGE_PROPERTIES
    client.crop_hints_detection opts if feature == :CROP_HINTS
    client.web_detection opts if feature == :WEB_DETECTION
    client.object_localization_detection opts if feature == :OBJECT_LOCALIZATION
  end

  def run_scenario image, feature_type
    Google::Cloud::Vision::V1::Credentials.stub(:default, mock_credentials) do
      client = Google::Cloud::Vision::ImageAnnotator.new(version: :v1)
      stub = batch_annotate_stub image, feature_type
      client.stub(:batch_annotate_images, stub) do
        if image.is_a?(Array)
          make_helper_call client, {images: image }, feature_type
        else
          make_helper_call client, {image: image }, feature_type
        end
      end
    end
  end



  describe "face_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :FACE_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :FACE_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :FACE_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :FACE_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :FACE_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :FACE_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :FACE_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :FACE_DETECTION
    end
  end

  describe "landmark_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :LANDMARK_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :LANDMARK_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :LANDMARK_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :LANDMARK_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :LANDMARK_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :LANDMARK_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :LANDMARK_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :LANDMARK_DETECTION
    end
  end

  describe "logo_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :LOGO_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :LOGO_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :LOGO_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :LOGO_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :LOGO_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :LOGO_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :LOGO_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :LOGO_DETECTION
    end
  end

  describe "label_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :LABEL_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :LABEL_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :LABEL_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :LABEL_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :LABEL_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :LABEL_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :LABEL_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :LABEL_DETECTION
    end
  end

  describe "text_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :TEXT_DETECTION
    end
  end

  describe "document_text_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :DOCUMENT_TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :DOCUMENT_TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :DOCUMENT_TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :DOCUMENT_TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :DOCUMENT_TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :DOCUMENT_TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :DOCUMENT_TEXT_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :DOCUMENT_TEXT_DETECTION
    end
  end

  describe "safe_search_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :SAFE_SEARCH_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :SAFE_SEARCH_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :SAFE_SEARCH_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :SAFE_SEARCH_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :SAFE_SEARCH_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :SAFE_SEARCH_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :SAFE_SEARCH_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :SAFE_SEARCH_DETECTION
    end
  end

  describe "image_properties_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :IMAGE_PROPERTIES
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :IMAGE_PROPERTIES
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :IMAGE_PROPERTIES
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :IMAGE_PROPERTIES
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :IMAGE_PROPERTIES
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :IMAGE_PROPERTIES
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :IMAGE_PROPERTIES
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :IMAGE_PROPERTIES
    end
  end

  describe "crop_hints_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :CROP_HINTS
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :CROP_HINTS
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :CROP_HINTS
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :CROP_HINTS
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :CROP_HINTS
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :CROP_HINTS
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :CROP_HINTS
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :CROP_HINTS
    end
  end

  describe "web_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :WEB_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :WEB_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :WEB_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :WEB_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :WEB_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :WEB_DETECTION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :WEB_DETECTION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :WEB_DETECTION
    end
  end

  describe "object_localization_detection" do
    it "correctly calls batch_annotate_images when given a single image path" do
      run_scenario image_path, :OBJECT_LOCALIZATION
    end
    it "correctly calls batch_annotate_images when given a list of image paths" do
      run_scenario image_paths, :OBJECT_LOCALIZATION
    end
    it "correctly calls batch_annotate_images when given a single file" do
      run_scenario image_file, :OBJECT_LOCALIZATION
    end
    it "correctly calls batch_annotate_images when given a list of files" do
      run_scenario image_files, :OBJECT_LOCALIZATION
    end
    it "correctly calls batch_annotate_images when given a single image uri" do
      run_scenario image_uri, :OBJECT_LOCALIZATION
    end
    it "correctly calls batch_annotate_images when given a list of image uri's" do
      run_scenario image_uris, :OBJECT_LOCALIZATION
    end
    it "correctly calls batch_annotate_images when given a single gcs image uri" do
      run_scenario gcs_image_uri, :OBJECT_LOCALIZATION
    end
    it "correctly calls batch_annotate_images when given a list of gcs image uri's" do
      run_scenario gcs_image_uri, :OBJECT_LOCALIZATION
    end
  end
end
