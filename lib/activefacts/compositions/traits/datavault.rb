module ActiveFacts
  module Compositions
    module Traits
      module DataVault
        def datavault_options
          {
            # Structural options:
            audit: [%w{record batch}, "Add date/source auditing fields to each record (hub/link/staging) or via a LoadBatch table"],
            # Variation options:
            loadbatch: ['String', "Change the name of the load batch table from LoadBatch"],
            datestamp: ['String', "Data type name to use for audit date stamps (default: DateTime)"],
            source: ['String', "Data type name to use for audit source (default: String)"],
          }
        end

        def datavault_initialize options
          @option_audit = options.delete('audit')

          case @option_loadbatch = options.delete('loadbatch')
          when true, 'true', 'yes'
            @option_loadbatch = 'LoadBatch'
          when false, 'false'
            @option_loadbatch = nil
          end
          @option_loadbatch ||= 'LoadBatch' if @option_audit == 'batch'

          case @option_datestamp = options.delete('datestamp')
          when true, '', 'true', 'yes', nil
            @option_datestamp = 'DateTime'
          when false, 'false'
            @option_datestamp = nil
          end

          case @option_source = options.delete('source')
          when true, '', 'true', 'yes', nil
            @option_source = 'String'
          when false, 'false'
            @option_source = nil
          end

        end

        def compile text
          @vocabulary = @constellation.Vocabulary.values[0]
          @compiler ||= ActiveFacts::CQL::Compiler.new(@vocabulary, constellation: @constellation)
          @compiler.compile("schema #{@vocabulary.name};\n"+text)
        end

        def create_loadbatch
          return unless @option_audit == 'batch' && @option_loadbatch

          schema_text = %Q{
            each #{@option_loadbatch} ID is written as an Auto Counter auto-assigned at commit;
            each #{@option_loadbatch} is independent identified by its ID;
          }
          compile(schema_text)
          @loadbatch_entity_type = @constellation.EntityType[[@vocabulary.identifying_role_values, @option_loadbatch]]
        end

        def inject_loadbatch_relationships
          return unless @option_audit == 'batch'

          @composition.all_composite.each do |composite|
            next if composite.mapping.object_type == @loadbatch_entity_type
            compile("#{composite.mapping.name} was loaded in one #{@option_loadbatch};")
          end
          @loadbatch_entity_type.all_role.each do |role|
            populate_reference(role).injection_annotation = 'loadbatch'
            populate_reference(role.counterpart).injection_annotation = 'loadbatch'
          end
        end

        def inject_audit_fields composite
          if datestamp_type
            # Add a load DateTime value
            date_field = @constellation.ValidFrom(:new,
              parent: composite.mapping,
              name: "LoadTime",
              object_type: datestamp_type,
              injection_annotation: "datavault"
            )
          end

          if recordsource_type
            # Add a load DateTime value
            recsrc_field = @constellation.ValueField(:new,
              parent: composite.mapping,
              name: "RecordSource",
              object_type: recordsource_type,
              injection_annotation: "datavault"
            )
          end
          composite.mapping.re_rank
          date_field
        end

        def datestamp_type_name
          @option_datestamp
        end

        def datestamp_type
          @datestamp_type ||= begin
            @vocabulary ||= @composition.all_composite.to_a[0].mapping.object_type.vocabulary
            @constellation.ObjectType[[[@vocabulary.name], datestamp_type_name]] or
              @constellation.ValueType(
                vocabulary: @vocabulary,
                name: datestamp_type_name,
                concept: [:new, :implication_rule => "datestamp injection"]
              )
          end
        end

        def recordsource_type_name
          @option_source
        end

        def recordsource_type
          @recordsource_type ||= begin
            @vocabulary ||= @composition.all_composite.to_a[0].mapping.object_type.vocabulary
            @constellation.ObjectType[[[@vocabulary.name], recordsource_type_name]] or
              @constellation.ValueType(
                vocabulary: @vocabulary,
                name: recordsource_type_name,
                concept: [:new]
              )
          end
        end

        #
        # Rename parents functions defined because they are used in both Staging and Datavault subclasses
        #
        def apply_name_pattern pattern, name
          pattern.sub(/\+/, name)
        end

        def apply_composite_name_pattern
          @composites.each do |key, composite|
            next if composite.mapping.name == @option_loadbatch
            composite.mapping.name = apply_name_pattern(@option_stg_name, composite.mapping.name)
          end
        end
      end
    end
  end
end
