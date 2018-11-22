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
require "google/cloud/vision/helpers"



describe Google::Cloud::Vision do
  Google::Cloud::Vision::AVAILABLE_VERSIONS.each do |version|
    require "google/cloud/vision/#{version}/image_annotator_client"

    Object.const_set("MockImageAnnotatorCredentials_#{version}",
      Class.new(Google::Cloud::Vision.const_get(version.capitalize)::Credentials) do
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
    )

    let(:helper_methods) do
      helper_hash = {}
      Google::Cloud::Vision.const_get(version.capitalize)::Feature::Type.constants.each do |feature_type|
        next if feature_type == :TYPE_UNSPECIFIED
        method_name = feature_type.to_s.downcase
        method_name += "_detection" unless method_name.include? "detection"
        helper_hash[method_name] = feature_type
      end
    end
    let(:image_variants) do 
      {
        "single image file": File.new("acceptance/data/face.jpg", "r"),
        "list of image files": (0..1).map { File.new("acceptance/data/face.jpg", "r") },
        "single image path": "acceptance/data/face.jpg",
        "list of image paths": (0..1).map { "acceptance/data/face.jpg" },
        "single image uri": "http://example.com/face.jpg",
        "list of image uri's": (0..1).map { "http://example.com/face.jpg" },
        "single gcs image uri": "gs://gapic-toolkit/President_Barack_Obama.jpg",
        "list of gcs image uri's": (0..1).map { "gs://gapic-toolkit/President_Barack_Obama.jpg" }
      }
    end
    let(:mock_credentials) { Object.const_get("MockImageAnnotatorCredentials_#{version}").new("batch_annotate_images") }
    # let(:feature_types)
  
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

    describe Google::Cloud::Vision.const_get(version.capitalize)::ImageAnnotatorClient do
      it "generates helper methods based on Feature.Types" do
        helper_methods.each do |helper_method, feature_type|
          describe helper_method do
            it "formats images correctly" do
              image_variants.each do |description, image|
                it "correctly calls batch_annotate_images when given a #{description}" do
      
                  Google::Cloud::Vision.const_get(version.capitalize)::Credentials.stub(:default, mock_credentials) do
                    client = Google::Cloud::Vision::ImageAnnotator.new(version: version.to_sym)
                    stub = batch_annotate_stub image, feature_type
                    client.stub(:batch_annotate_images, stub) do
                      if image.is_a?(Array)
                        client.public_send(helper_method, images: image)
                      else
                        client.public_send(helper_method, image: image)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
