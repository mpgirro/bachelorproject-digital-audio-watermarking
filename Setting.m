classdef Setting
    
    properties(Constant = true)
        SUBBAND_COUNT = 3;
    end
    
    methods(Static = true)
        
        function [wavelet] = dwt_wavelet()
            sObj = SettingSingleton.instance();
            wavelet = sObj.getDwtWavelet;
        end
        
        function [level] = dwt_level()
            sObj = SettingSingleton.instance();
            level = sObj.getDwtLevel;
        end
        
        function [length] = subband_length()
            sObj = SettingSingleton.instance();
            length = sObj.getSubbandLength;
        end
        
        
        function [esf] = embedding_strength_factor()
            sObj = SettingSingleton.instance();
            esf = sObj.getEmbeddingStrengthFactor;
        end
        
        
        % sync code = base sync code with local redundancy applied
        function code = sync_code()
            sObj = SettingSingleton.instance();
            code = sObj.getSynchronizationCode;
%             baseCode        = sObj.getBaseSynchronizationCode;
%             redundancyRate  = Setting.synccode_redundancy_rate;
%     
%             % e.g. makes [1,0,1] to [1,1,1,0,0,0,1,1,1] if redundancyRate = 3
%             code = reshape(repmat(baseCode,redundancyRate,1),[],1)'; % don't forget the ' at the end!
        end
        
        % amount of samples needed to encode 1 bit
        function [length] = frame_length()
            sObj = SettingSingleton.instance();
            length = 3* sObj.getSubbandLength * 2 ^ sObj.getDwtLevel;
        end
        
        function length = bufferzone_length()
            sObj = SettingSingleton.instance();
            length = floor(Setting.frame_length * sObj.getBufferzoneScalingFactor);
        end
        
        function length = synccode_block_sequence_length()
            codeSize = size(Setting.sync_code);
            length = codeSize(2);
        end
        
        function length = wmkdata_block_sequence_length()
            sObj = SettingSingleton.instance();
            length = sObj.getWmkDataBlockSequenceLength;
        end
        
        function length = datastruct_package_sequence_length()
            length = Setting.synccode_block_sequence_length + Setting.wmkdata_block_sequence_length;
        end
        
        function length = synccode_block_sample_length()
            length = Setting.frame_length * Setting.synccode_block_sequence_length;
        end
        
        function length = wmkdata_block_sample_length()
            length = Setting.frame_length * Setting.wmkdata_block_sequence_length;
        end
        
        function length = datastruct_package_sample_length()
            length = Setting.synccode_block_sample_length + Setting.wmkdata_block_sample_length;
        end
        
    end
end

