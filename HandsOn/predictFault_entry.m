function Y = predictFault_entry(X)
%codegen
net = coder.loadDeepLearningNetwork('./quantized_net.mat');
Y = net.predict(dlarray(X,'TCB'));
end