function threeD_synthesis(hrir_mat_file_s,sound_file_s,trajectory_file_s);

%	threeD_synthesis(subject_n,hrir_mat_directory_s,sound_directory_s{,trajectory_file_s});
%
%	subject_n		: number of the subject (e.g., 1002)
%	hrir_mat_directory_s	: path of the HRIR WAV files (ending with separator)
%	sound_directory_s	: path of the sound file (ending with separator)
%	trajectory_file_s	: path of the trajectory file
%				  (three columns : elevation, azimuth, time in samples)
%
% Load HRIR from Matlab file, window HRIR and perform diffuse field equalization,
% and save compensated HRIR (WAV files and unique Matlab file)


% DEFAULT VALUES
sound_length_sec = .3;
sound_step_sec = sound_length_sec + 0.1;
sampling_hz = 16000;


if exist('trajectory_file_s') ~= 1
      elevation = -15;
      trajectory_S.elev_v = elevation .* ones(25,1);
      trajectory_S.azim_v = [180:15:345 0:15:180]';
      trajectory_S.time_v = [0:sound_step_sec:sound_step_sec*24]'*sampling_hz+1;
else
      eval(['trajectory = load(''' trajectory_file_s ''');']);
      trajectory_S.elev_v = trajectory(:,1);
      trajectory_S.azim_v = trajectory(:,2);
      trajectory_S.time_v = trajectory(:,3);
end

% LOADING MAT FILES
load([hrir_mat_file_s],'l_hrir_S','r_hrir_S');

% Sound synthesis (in samples)
sound_length_n = round(sound_length_sec*sampling_hz);
anechoic_sound_v = test_noise('Modulated',sound_length_n,sampling_hz);

voice = audioread('voice.wav');
noise = 0.2*test_noise('Modulated',length(voice),sampling_hz);
tr1.elev_v = -15;
tr1.azim_v = 45;
tr1.time_v = 1;
tr2.elev_v = -15;
tr2.azim_v = 315;
tr2.time_v = 1;

% 3d synthesis
[noiseSyn]=raw_synthesis(l_hrir_S,r_hrir_S,noise,tr2);
[voiceSyn]=raw_synthesis(l_hrir_S,r_hrir_S,voice,tr1);

% Normalization
%sound_m = sound_m/max(max(abs(sound_m)))/1.01;

noisyVoice = voice + noise;
%noisyVoice = voiceSyn + noiseSyn;

% User input
if ~exist('sound_file_s')
  [file_name_s,path_name_s] = uiputfile( ...
	{'*.wav', 'All WAV Files (*.wav)'; '*.*', 'All Files (*.*)'}, ...
	'Save the sound file');
  pause(0);
  if isequal(file_name_s,0)|isequal(path_name_s,0)
    disp('File not found');
    return;
  end;
  sound_file_s = [path_name_s, file_name_s];
end;

% Writing binaural WAV file
%file_name_s = sprintf('IRC_%d_S_P%03d',subject_n,elevation);
%wavwrite_ext(sound_m,44100,16,sound_file_s);

audiowrite('out.wav', noisyVoice, sampling_hz);
