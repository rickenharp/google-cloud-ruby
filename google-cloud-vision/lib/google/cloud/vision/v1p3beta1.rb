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


require "google/cloud/vision/v1p3beta1/product_search_client"
require "google/cloud/vision/v1p3beta1/image_annotator_client"
require "google/cloud/vision/v1p3beta1/image_annotator_pb"
require "google/cloud/vision/v1p3beta1/product_search_service_pb"

module Google
  module Cloud
    module Vision
      # rubocop:disable LineLength

      ##
      # # Ruby Client for Cloud Vision API ([Alpha](https://github.com/googleapis/google-cloud-ruby#versioning))
      #
      # [Cloud Vision API][Product Documentation]:
      # Integrates Google Vision features, including image labeling, face, logo, and
      # landmark detection, optical character recognition (OCR), and detection of
      # explicit content, into applications.
      # - [Product Documentation][]
      #
      # ## Quick Start
      # In order to use this library, you first need to go through the following
      # steps:
      #
      # 1. [Select or create a Cloud Platform project.](https://console.cloud.google.com/project)
      # 2. [Enable billing for your project.](https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_project)
      # 3. [Enable the Cloud Vision API.](https://console.cloud.google.com/apis/library/vision.googleapis.com)
      # 4. [Setup Authentication.](https://googleapis.github.io/google-cloud-ruby/#/docs/google-cloud/master/guides/authentication)
      #
      # ### Installation
      # ```
      # $ gem install google-cloud-vision
      # ```
      #
      # ### Preview
      # #### ImageAnnotatorClient
      # ```rb
      # require "google/cloud/vision"
      #
      # image_annotator_client = Google::Cloud::Vision::ImageAnnotator.new(version: :v1p3beta1)
      # gcs_image_uri = "gs://gapic-toolkit/President_Barack_Obama.jpg"
      # source = { gcs_image_uri: gcs_image_uri }
      # image = { source: source }
      # type = :FACE_DETECTION
      # features_element = { type: type }
      # features = [features_element]
      # requests_element = { image: image, features: features }
      # requests = [requests_element]
      # response = image_annotator_client.batch_annotate_images(requests)
      # ```
      #
      # ### Next Steps
      # - Read the [Cloud Vision API Product documentation][Product Documentation]
      #   to learn more about the product and see How-to Guides.
      # - View this [repository's main README](https://github.com/googleapis/google-cloud-ruby/blob/master/README.md)
      #   to see the full list of Cloud APIs that we cover.
      #
      # [Product Documentation]: https://cloud.google.com/vision
      #
      # ## Enabling Logging
      #
      # To enable logging for this library, set the logger for the underlying [gRPC](https://github.com/grpc/grpc/tree/master/src/ruby) library.
      # The logger that you set may be a Ruby stdlib [`Logger`](https://ruby-doc.org/stdlib-2.5.0/libdoc/logger/rdoc/Logger.html) as shown below,
      # or a [`Google::Cloud::Logging::Logger`](https://googleapis.github.io/google-cloud-ruby/#/docs/google-cloud-logging/latest/google/cloud/logging/logger)
      # that will write logs to [Stackdriver Logging](https://cloud.google.com/logging/). See [grpc/logconfig.rb](https://github.com/grpc/grpc/blob/master/src/ruby/lib/grpc/logconfig.rb)
      # and the gRPC [spec_helper.rb](https://github.com/grpc/grpc/blob/master/src/ruby/spec/spec_helper.rb) for additional information.
      #
      # Configuring a Ruby stdlib logger:
      #
      # ```ruby
      # require "logger"
      #
      # module MyLogger
      #   LOGGER = Logger.new $stderr, level: Logger::WARN
      #   def logger
      #     LOGGER
      #   end
      # end
      #
      # # Define a gRPC module-level logger method before grpc/logconfig.rb loads.
      # module GRPC
      #   extend MyLogger
      # end
      # ```
      #
      module V1p3beta1
        # rubocop:enable LineLength

        module ProductSearch
          ##
          # Manages Products and ProductSets of reference images for use in product
          # search. It uses the following resource model:
          #
          # * The API has a collection of {Google::Cloud::Vision::V1p3beta1::ProductSet ProductSet} resources, named
          #   `projects/*/locations/*/productSets/*`, which acts as a way to put different
          #   products into groups to limit identification.
          #
          # In parallel,
          #
          # * The API has a collection of {Google::Cloud::Vision::V1p3beta1::Product Product} resources, named
          #   `projects/*/locations/*/products/*`
          #
          # * Each {Google::Cloud::Vision::V1p3beta1::Product Product} has a collection of {Google::Cloud::Vision::V1p3beta1::ReferenceImage ReferenceImage} resources, named
          #   `projects/*/locations/*/products/*/referenceImages/*`
          #
          # @param credentials [Google::Auth::Credentials, String, Hash, GRPC::Core::Channel, GRPC::Core::ChannelCredentials, Proc]
          #   Provides the means for authenticating requests made by the client. This parameter can
          #   be many types.
          #   A `Google::Auth::Credentials` uses a the properties of its represented keyfile for
          #   authenticating requests made by this client.
          #   A `String` will be treated as the path to the keyfile to be used for the construction of
          #   credentials for this client.
          #   A `Hash` will be treated as the contents of a keyfile to be used for the construction of
          #   credentials for this client.
          #   A `GRPC::Core::Channel` will be used to make calls through.
          #   A `GRPC::Core::ChannelCredentials` for the setting up the RPC client. The channel credentials
          #   should already be composed with a `GRPC::Core::CallCredentials` object.
          #   A `Proc` will be used as an updater_proc for the Grpc channel. The proc transforms the
          #   metadata for requests, generally, to give OAuth credentials.
          # @param scopes [Array<String>]
          #   The OAuth scopes for this service. This parameter is ignored if
          #   an updater_proc is supplied.
          # @param client_config [Hash]
          #   A Hash for call options for each method. See
          #   Google::Gax#construct_settings for the structure of
          #   this data. Falls back to the default config if not specified
          #   or the specified config is missing data points.
          # @param timeout [Numeric]
          #   The default timeout, in seconds, for calls made through this client.
          # @param metadata [Hash]
          #   Default metadata to be sent with each request. This can be overridden on a per call basis.
          # @param exception_transformer [Proc]
          #   An optional proc that intercepts any exceptions raised during an API call to inject
          #   custom error handling.
          def self.new \
              credentials: nil,
              scopes: nil,
              client_config: nil,
              timeout: nil,
              metadata: nil,
              exception_transformer: nil,
              lib_name: nil,
              lib_version: nil
            kwargs = {
              credentials: credentials,
              scopes: scopes,
              client_config: client_config,
              timeout: timeout,
              metadata: metadata,
              exception_transformer: exception_transformer,
              lib_name: lib_name,
              lib_version: lib_version
            }.select { |_, v| v != nil }
            Google::Cloud::Vision::V1p3beta1::ProductSearchClient.new(**kwargs)
          end
        end

        module ImageAnnotator
          ##
          # Service that performs Google Cloud Vision API detection tasks over client
          # images, such as face, landmark, logo, label, and text detection. The
          # ImageAnnotator service returns detected entities from the images.
          #
          # @param credentials [Google::Auth::Credentials, String, Hash, GRPC::Core::Channel, GRPC::Core::ChannelCredentials, Proc]
          #   Provides the means for authenticating requests made by the client. This parameter can
          #   be many types.
          #   A `Google::Auth::Credentials` uses a the properties of its represented keyfile for
          #   authenticating requests made by this client.
          #   A `String` will be treated as the path to the keyfile to be used for the construction of
          #   credentials for this client.
          #   A `Hash` will be treated as the contents of a keyfile to be used for the construction of
          #   credentials for this client.
          #   A `GRPC::Core::Channel` will be used to make calls through.
          #   A `GRPC::Core::ChannelCredentials` for the setting up the RPC client. The channel credentials
          #   should already be composed with a `GRPC::Core::CallCredentials` object.
          #   A `Proc` will be used as an updater_proc for the Grpc channel. The proc transforms the
          #   metadata for requests, generally, to give OAuth credentials.
          # @param scopes [Array<String>]
          #   The OAuth scopes for this service. This parameter is ignored if
          #   an updater_proc is supplied.
          # @param client_config [Hash]
          #   A Hash for call options for each method. See
          #   Google::Gax#construct_settings for the structure of
          #   this data. Falls back to the default config if not specified
          #   or the specified config is missing data points.
          # @param timeout [Numeric]
          #   The default timeout, in seconds, for calls made through this client.
          # @param metadata [Hash]
          #   Default metadata to be sent with each request. This can be overridden on a per call basis.
          # @param exception_transformer [Proc]
          #   An optional proc that intercepts any exceptions raised during an API call to inject
          #   custom error handling.
          def self.new \
              credentials: nil,
              scopes: nil,
              client_config: nil,
              timeout: nil,
              metadata: nil,
              exception_transformer: nil,
              lib_name: nil,
              lib_version: nil
            kwargs = {
              credentials: credentials,
              scopes: scopes,
              client_config: client_config,
              timeout: timeout,
              metadata: metadata,
              exception_transformer: exception_transformer,
              lib_name: lib_name,
              lib_version: lib_version
            }.select { |_, v| v != nil }
            Google::Cloud::Vision::V1p3beta1::ImageAnnotatorClient.new(**kwargs)
          end
        end
      end
    end
  end
end
