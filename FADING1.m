
clear spectrum spectrumAnalyzer

timeScope = timescope('SampleRate', Fs, ...
    'TimeSpanOverrunAction', 'scroll', ...
    'TimeSpanSource', 'property', ...
    'TimeSpan', 3.75e-07);
timeScope(waveform);
release(timeScope);

specBefore = spectrumAnalyzer('SampleRate', Fs);
specBefore(waveform);
release(specBefore);


fs = 80e6; % Match sample rate

chan = comm.RayleighChannel( ...
    'SampleRate', fs, ...
    'PathDelays', [0, 1.5e-6, 3e-6], ...
    'AveragePathGains', [0, -3, -8], ...
    'MaximumDopplerShift', 30);

% Apply fading
fadedWaveform = chan(waveform);

% Add AWGN noise
fadedWaveform = awgn(fadedWaveform, 15, 'measured');

% Visualize constellation
cd = comm.ConstellationDiagram('Title','Rayleigh Faded Signal');
cd(fadedWaveform);

% Spectrum after fading
specAfter = dsp.SpectrumAnalyzer('SampleRate', fs);
specAfter(fadedWaveform);